//
//  CastOrCrewMemberDetail.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 25/05/26.
//

import SwiftUI
import SwiftData

struct MoviePicker: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \Movie.title) private var movies: [Movie]
    @State private var searchString: String = ""
    
    var selectedMember: CastOrCrewMember? = nil
    
    var onSelect: (Movie) -> Void
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if !filteredMovies.isEmpty {
                List {
                    ForEach(filteredMovies) { movie in
                        Button {
                            onSelect(movie)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    movieTitleText(for: movie)
                                    movieReleaseDateText(for: movie)
                                }
                                Spacer()
                                if isMovieSelected(movie) {
                                    checkmarkIcon
                                }
                            }
                        }
                    }
                }
            } else {
                ContentUnavailableView(
                    "No movies found",
                    systemImage: "arrow.backward",
                )
                
            }
        }
        .searchable(text: $searchString)
        .navigationTitle("Select Movie")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                cancelButton
            }
        }
    }

    // MARK: - Helpers

    private func isMovieSelected(_ movie: Movie) -> Bool {
        guard let member = selectedMember else { return false }
        return member.movies.contains(where: { $0 === movie })
    }

    // MARK: - Subviews
    
    private func movieTitleText(for movie: Movie) -> some View {
        Text(movie.title)
    }
    
    private func movieReleaseDateText(for movie: Movie) -> some View {
        Text(
            movie.releaseDate,
            style: .date
        )
        .font(.caption)
        .foregroundColor(.secondary)
    }
    
    private var checkmarkIcon: some View {
        Image(systemName: "checkmark")
            .foregroundColor(.accentColor)
    }
    
    // MARK: Toolbar buttons
    
    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }
    
    // MARK: - Functions
    
    private var filteredMovies: [Movie] {
        guard !searchString.isEmpty else { return movies }
        return movies.filter { $0.title.localizedStandardContains(searchString) }
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        MoviePicker(
            selectedMember: CastOrCrewMember.sampleData[0],
        ) { _ in }
            .modelContainer(SampleData.shared.modelContainer)
    }
}

#Preview("Empty movies list") {
    NavigationStack {
        MoviePicker { _ in }
    }
}
