//
//  MovieDetail.swift
//  FriendsFavoriteMovies
//
//  Created by Feed0 on 01/04/26.
//

import SwiftUI
import SwiftData

struct MovieDetail: View {
    
    // MARK: - Properties
    
    @Bindable var movie: Movie
    let isNew: Bool
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
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
            
            if showFavoritedBySection {
                Section("Favorited by") {
                    ForEach(sortedFriends) { friend in
                        friendNameText(for: friend)
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
        }
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
    
    private func friendNameText(for friend: Friend) -> some View {
        Text(friend.name)
    }
    
    // MARK: - Private funcs
    
    private func handleSaveButton() {
        dismiss()
    }
    
    private func handleCancelButton() {
        context.delete(movie)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        MovieDetail(
            movie: SampleData.shared.movie
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
