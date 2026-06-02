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
    @State private var showFriendPicker = false
    
    // MARK: Computed properties
    
    private var navigationTitle: String {
        isNew ? "New Movie" : "Movie"
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
            
            Section("Favorited by") {
                movieFavoritedByList
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

            ToolbarItem {
                addNewFriendRelationShipButton
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
        .sheet(isPresented: $showFriendPicker) {
            NavigationStack {
                friendPicker
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

    private var movieFavoritedByList: some View {
        MovieFavoritedByList(
            movie: movie,
            friendFilter: searchString,
        )
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

    private var addNewFriendRelationShipButton: some View {
        Button(
            "Add friend",
            systemImage: "person.fill.badge.plus"
        ) {
            handleAddNewFriendRelationshipButton()
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

    private var friendPicker: some View {
        FriendPicker(
            currentFavorites: movie.favoritedBy,
        ) { selectedFriends in
            for friend in selectedFriends {
                if !movie.favoritedBy.contains(where: { $0 === friend }) {
                    movie.favoritedBy.append(friend)
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

    private func handleAddNewFriendRelationshipButton() {
        showFriendPicker = true
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
