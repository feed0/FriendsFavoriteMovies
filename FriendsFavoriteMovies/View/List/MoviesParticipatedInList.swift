//
//  MoviesParticipatedInList.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 25/05/26.
//

import SwiftUI
import SwiftData

struct MoviesParticipatedInList: View {
    
    // MARK: - Properties
    
    @Bindable var castOrCrewMember: CastOrCrewMember
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if !castOrCrewMember.movies.isEmpty {
                List {
                    ForEach(castOrCrewMember.movies) { movie in
                        Text(movie.title)
                    }
                    .onDelete(perform: deleteMoviesCrewRelationship(indexes:))
                }
            } else {
                ContentUnavailableView(
                    "Add participations in movies",
                    systemImage: "link.badge.plus"
                )
            }
        }
    }
    
    // MARK: - Functions
    
    private func deleteMoviesCrewRelationship(indexes: IndexSet) {
        for index in indexes {
            castOrCrewMember.movies.remove(at: index)
        }
    }
}

#Preview {
    NavigationStack {
        MoviesParticipatedInList(
            castOrCrewMember: CastOrCrewMember.sampleData[0],
        )
        .modelContainer(SampleData.shared.modelContainer)
    }
}

#Preview("Empty list") {
    NavigationStack {
        MoviesParticipatedInList(
            castOrCrewMember: CastOrCrewMember.sampleData[2],
        )
        .modelContainer(SampleData.shared.modelContainer)
    }
}
