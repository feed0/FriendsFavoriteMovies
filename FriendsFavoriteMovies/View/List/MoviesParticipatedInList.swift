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
    private let titleFilter: String
    
    // MARK: Computed properties
    
    private var filteredMovies: [Movie] {
        guard !titleFilter.isEmpty else { return castOrCrewMember.movies }
        return castOrCrewMember.movies.filter {
            $0.title.localizedStandardContains(titleFilter)
        }
    }
    
    // MARK: - Init
    
    init(
        castOrCrewMember: CastOrCrewMember,
        titleFilter: String = ""
    ) {
        self.castOrCrewMember = castOrCrewMember
        self.titleFilter = titleFilter
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if !filteredMovies.isEmpty {
                List {
                    ForEach(filteredMovies) { movie in
                        HStack {
                            movieTitleText(for: movie)
                            Spacer()
                            movieReleaseDateText(for: movie)
                        }
                    }
                    .onDelete(perform: deleteMoviesCrewRelationship(indexes:))
                }
            } else {
                contentUnavailableView
            }
        }
    }
    
    // MARK: - Subviews
    
    private func movieTitleText(for movie: Movie) -> some View {
        Text(movie.title)
    }
    
    private func movieReleaseDateText(for movie: Movie) -> some View {
        Text(
            movie.releaseDate.formatted(
                date: .numeric,
                time: .omitted
            )
            .description
        )
        .font(.footnote)
    }
    
    // MARK: - Functions
    
    private func deleteMoviesCrewRelationship(indexes: IndexSet) {
        for index in indexes {
            let movie = filteredMovies[index]
            if let movieIndex = castOrCrewMember.movies.firstIndex(where: { $0 === movie }) {
                castOrCrewMember.movies.remove(at: movieIndex)
            }
        }
    }
    
    private var contentUnavailableView: some View {
        ContentUnavailableView(
            "Add participations in movies",
            systemImage: "link.badge.plus"
        )
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

#Preview("Filtered") {
    NavigationStack {
        MoviesParticipatedInList(
            castOrCrewMember: CastOrCrewMember.sampleData[0],
            titleFilter: "am",
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
