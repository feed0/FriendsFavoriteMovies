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
    
    @Query private var movies: [Movie]
    
    @State private var newMovie: Movie?
    
    // MARK: - Init
    
    init(
        titleFilter: String = "",
    ) {
        let predicate = #Predicate<Movie> { movie in
            titleFilter.isEmpty
            || movie.title.localizedStandardContains(titleFilter)
        }

        _movies = Query(
            filter: predicate,
            sort: \Movie.title,
        )
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(movies) { movie in
                    NavigationLink(movie.title) {
                        movieDetail(for: movie)
                    }
                }
                .onDelete(perform: deleteMovies(indexes:))
            }
            .navigationTitle("Movies")
            .toolbar {
                ToolbarItem {
                    addMovieButton
                }
                ToolbarItem {
                    EditButton()
                }
            }
            .sheet(item: $newMovie) { movie in
                NavigationStack {
                    newMovieDetail(for: movie)
                }
                .interactiveDismissDisabled()
            }
        } detail: {
            defaultDetailLink
        }
    }
    
    // MARK: - Subviews
    
    private func movieDetail(for movie: Movie) -> some View {
        MovieDetail(movie: movie)
    }
    
    private func newMovieDetail(for movie: Movie) -> some View {
        MovieDetail(
            movie: movie,
            isNew: true
        )
    }
    
    private var addMovieButton: some View {
        Button(
            "Add movie",
            systemImage: "plus",
            action: addMovie
        )
    }
    
    private var defaultDetailLink: some View {
        Text("Select a movie")
            .navigationTitle("Movie")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Private funcs
    
    private func addMovie() {
        let newMovie = Movie(title: "", releaseDate: .now)
        context.insert(newMovie)
        self.newMovie = newMovie
    }
    
    private func deleteMovies(indexes: IndexSet) {
        for index in indexes {
            context.delete(movies[index])
        }
    }
}

#Preview {
    MovieList()
        .modelContainer(SampleData.shared.modelContainer)
}

#Preview("Filtered") {
    MovieList(titleFilter: "tr")
        .modelContainer(SampleData.shared.modelContainer)
}
