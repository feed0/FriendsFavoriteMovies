//
//  MovieList.swift
//  FriendsFavoriteMovies
//
//  Created by Felipe Campelo on 25/03/26.
//

import SwiftUI
import SwiftData

struct MovieList: View {
    
    // MARK: - Properties
    
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Movie.title) private var movies: [Movie]
    
    // MARK: - Body
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(movies) { movie in
                    NavigationLink(movie.title) {
                        movieDetail(for: movie)
                    }
                }
            }
            .navigationTitle("Movies")
        } detail: {
            defaultDetailLink
        }
    }
    
    // MARK: - Subviews
    
    private func movieDetail(for movie: Movie) -> some View {
        MovieDetail(movie: movie)
    }
    
    private var defaultDetailLink: some View {
        Text("Select a movie")
            .navigationTitle("Movie")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MovieList()
        .modelContainer(SampleData.shared.modelContainer)
}
