//
//  CastOrCrewMemberDetail.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 25/05/26.
//

import SwiftUI
import SwiftData

struct CastOrCrewMemberDetail: View {
    
    // MARK: - Init
    
    init(
        for castOrCrewMember: CastOrCrewMember,
        isNew: Bool = false,
    ) {
        self.castOrCrewMember = castOrCrewMember
        self.isNewCastOrCrewMember = isNew
    }
    
    // MARK: - Properties
    
    @Bindable var castOrCrewMember: CastOrCrewMember
    private let isNewCastOrCrewMember: Bool
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var showMoviePicker: Bool = false
    
    // MARK: Computed properties
    
    var navigationTitle: String {
        isNewCastOrCrewMember ? "New Cast or Crew Member" : castOrCrewMember.name
    }
    
    // MARK: - Body
    
    var body: some View {
        Form {
            castOrCrewMemberNameTextField
            castOrCrewMemberRoleTextField
            
            Section("Movies participated in"){
                MoviesParticipatedInList(
                    castOrCrewMember: castOrCrewMember,
                )
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isNewCastOrCrewMember {
                ToolbarItem(placement: .confirmationAction) {
                    saveButton
                }
                ToolbarItem(placement: .cancellationAction) {
                    cancelButton
                }
            }
            
            ToolbarItem {
                addNewMovieRelationshipButton
            }
            
            if !isNewCastOrCrewMember {
                ToolbarItem {
                    editButton
                }
            }
        }
        .sheet(isPresented: $showMoviePicker) {
            NavigationStack {
                moviePicker
            }
        }
    }
    
    // MARK: - Subviews
    
    private var castOrCrewMemberNameTextField: some View {
        TextField(
            "Name",
            text: $castOrCrewMember.name
        )
        .autocorrectionDisabled()
    }
    
    private var castOrCrewMemberRoleTextField: some View {
        TextField(
            "Role",
            text: $castOrCrewMember.role
        )
    }
    
    private var moviePicker: some View {
        MoviePicker(selectedMember: castOrCrewMember) { movie in
            if shouldAppendMovie(movie) {
                castOrCrewMember.movies.append(movie)
            }
            
            showMoviePicker = false
        }
    }
    
    // MARK: Toolbar buttons
    
    private var saveButton: some View {
        Button("Save") {
            handleSaveButton()
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            handleCancelButton()
        }
    }
    
    private var addNewMovieRelationshipButton: some View {
        Button(
            "Add movie",
            systemImage: "link.badge.plus"
        ) {
            handleAddNewMovieRelationshipButton()
        }
    }
    
    private var editButton: some View {
        EditButton()
    }
    
    // MARK: - Functions
    
    private func handleSaveButton() {
        dismiss()
    }
    
    private func handleCancelButton() {
        context.delete(castOrCrewMember)
        dismiss()
    }
    
    private func handleAddNewMovieRelationshipButton() {
        showMoviePicker = true
    }
    
    // MARK: MoviePicker functions
    
    private func shouldAppendMovie(_ movie: Movie) -> Bool {
        !castOrCrewMember.movies.contains(where: { $0 === movie })
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        CastOrCrewMemberDetail(
            for: CastOrCrewMember.sampleData[0],
        )
        .modelContainer(SampleData.shared.modelContainer)
    }
}

#Preview("New member") {
    let newMember = CastOrCrewMember(
        name: "New member",
        role: "New role",
    )
    
    NavigationStack {
        CastOrCrewMemberDetail(
            for: newMember,
            isNew: true,
        )
        .modelContainer(SampleData.shared.modelContainer)
    }
}
