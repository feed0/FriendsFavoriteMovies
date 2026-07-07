//
//  MovieFavoritedByList.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 02/06/26.
//

import SwiftUI
import SwiftData

struct MovieFavoritedByList: View {

    // MARK: - Properties

    @Bindable var movie: Movie
    private let friendFilter: String

    // MARK: Computed properties

    private var filteredFriends: [Friend] {
        let sortedFriends = movie.favoritedBy.sorted { first, second in
            first.name < second.name
        }

        guard !friendFilter.isEmpty else {
            return sortedFriends
        }

        return sortedFriends.filter {
            $0.name.localizedStandardContains(friendFilter)
        }
    }

    private var isContentAvailable: Bool {
        !filteredFriends.isEmpty
    }

    // MARK: - Init

    init(
        movie: Movie,
        friendFilter: String = ""
    ) {
        self.movie = movie
        self.friendFilter = friendFilter
    }

    // MARK: - Body

    var body: some View {
        Group {
            if isContentAvailable {
                List {
                    ForEach(filteredFriends) { friend in
                        friendNameText(for: friend)
                    }
                    .onDelete(perform: deleteMovieFavoriteRelationship(indexes:))
                }
            } else {
                contentUnavailableView
            }
        }
    }

    // MARK: - Subviews

    private func friendNameText(for friend: Friend) -> some View {
        Text(friend.name)
            .font(.body)
    }

    private var contentUnavailableView: some View {
        ContentUnavailableView(
            "No friends have favorited this movie",
            systemImage: "person.fill.questionmark"
        )
    }

    // MARK: - Functions

    private func deleteMovieFavoriteRelationship(indexes: IndexSet) {
        for index in indexes {
            let friend = filteredFriends[index]
            if let friendIndex = movie.favoritedBy.firstIndex(where: { $0 === friend }) {
                movie.favoritedBy.remove(at: friendIndex)
            }
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        MovieFavoritedByList(movie: Movie.sampleData[0])
            .modelContainer(SampleData.shared.modelContainer)
    }
}
