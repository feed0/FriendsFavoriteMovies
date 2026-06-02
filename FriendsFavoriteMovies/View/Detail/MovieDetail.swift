//
//  MovieDetail.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 01/04/26.
//

import SwiftUI
import SwiftData

struct MovieDetail: View {
    
    // MARK: - Properties
    
    @Bindable var movie: Movie
    let isNew: Bool
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var searchString = ""
    @State private var showCrewMemberPicker = false
    
    // MARK: Computed properties
    
    private var navigationTitle: String {
        isNew ? "New Movie" : "Movie"
    }
    
    private var showFavoritedBySection: Bool {
        !movie.favoritedBy.isEmpty
    }
    
    private var sortedFriends: [Friend] {
        movie.favoritedBy.sorted { first, second in
            first.name < second.name
        }
    }
    
    // MARK: - Init
    
    init(
        movie: Movie,
        isNew: Bool = false,
    ) {
        self.movie = movie
        self.isNew = isNew
    }
    
    // MARK: - Body
    
    var body: some View {
        Form {
            movieTextField
            releaseDatePicker
            
            Section("Cast & Crew") {
                movieCrewList
            }
            
            if showFavoritedBySection {
                Section("Favorited by") {
                    List {
                        ForEach(sortedFriends) { friend in
                            friendNameText(for: friend)
                        }
                        .onDelete(perform: deleteRelationship(indexes:))
                    }
                }
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    saveButton
                }
                ToolbarItem(placement: .cancellationAction) {
                    cancelButton
                }
            }
            
            ToolbarItem {
                addNewCrewRelationShipButton
            }
            
            if !isNew {
                ToolbarItem {
                    editButton
                }
            }
        }
        .sheet(isPresented: $showCrewMemberPicker) {
            NavigationStack {
                crewMemberPicker
            }
        }
        .searchable(text: $searchString)
    }
    
    // MARK: - Subviews
    
    private var movieTextField: some View {
        TextField(
            "Movie title",
            text: $movie.title
        )
    }
    
    private var releaseDatePicker: some View {
        DatePicker(
            "Release date",
            selection: $movie.releaseDate,
            displayedComponents: .date
        )
    }
    
    private var movieCrewList: some View {
        MovieCrewList(
            movie: movie,
            memberFilter: searchString,
        )
    }
    
    private func friendNameText(for friend: Friend) -> some View {
        Text(friend.name)
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
    
    private var addNewCrewRelationShipButton: some View {
        Button(
            "Add crew member",
            systemImage: "person.3.fill"
        ) {
            handleAddNewMovieRelationshipButton()
        }
    }
    
    private var editButton: some View {
        EditButton()
    }
    
    // MARK: Sheet
    
    private var crewMemberPicker: some View {
        CrewMemberPicker(
            currentMembers: movie.castAndCrew,
        ) { selectedMembers in
            for member in selectedMembers {
                if !movie.castAndCrew.contains(where: { $0 === member }) {
                    movie.castAndCrew.append(member)
                }
            }
        }
    }
    
    // MARK: - Private funcs
    
    // MARK: toolbar
    
    private func handleSaveButton() {
        dismiss()
    }
    
    private func handleCancelButton() {
        context.delete(movie)
        dismiss()
    }
    
    private func handleAddNewMovieRelationshipButton() {
        showCrewMemberPicker = true
    }
    
    // MARK: other
    
    private func deleteRelationship(indexes: IndexSet) {
        for index in indexes {
            movie.favoritedBy.remove(at: index)
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        MovieDetail(
            movie: Movie.sampleData[0]
        )
    }
}

#Preview("New Movie") {
    let newMovie = Movie(
        title: "",
        releaseDate: Date.now,
    )
    
    NavigationStack {
        MovieDetail(
            movie: newMovie,
            isNew: true
        )
    }
}
