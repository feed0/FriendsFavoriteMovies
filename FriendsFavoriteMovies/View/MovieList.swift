//
//  MovieList.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 25/03/26.
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
        Group {
            if !movies.isEmpty {
                List {
                    ForEach(movies) { movie in
                        NavigationLink(movie.title) {
                            movieDetail(for: movie)
                        }
                    }
                    .onDelete(perform: deleteMovies(indexes:))
                }
            } else {
                contentUnavailableView
            }
        }
        .navigationTitle("Movies")
        .toolbar {
            ToolbarItem {
                addMovieButton
            }
            ToolbarItem {
                editButton
            }
        }
        .sheet(item: $newMovie) { movie in
            NavigationStack {
                newMovieDetail(for: movie)
            }
            .interactiveDismissDisabled()
        }
    }
    
    // MARK: - Subviews
    
    // MARK: toolbar
    
    private var addMovieButton: some View {
        Button(
            "Add movie",
            systemImage: "plus",
            action: addMovie
        )
    }
    
    private var editButton: some View {
        EditButton()
    }
    
    // MARK: sheets
    
    private func movieDetail(for movie: Movie) -> some View {
        MovieDetail(movie: movie)
    }
    
    private func newMovieDetail(for movie: Movie) -> some View {
        MovieDetail(
            movie: movie,
            isNew: true
        )
    }
    
    // MARK: other
    
    private var contentUnavailableView: some View {
        ContentUnavailableView(
            "Add Friends",
            systemImage: "person.and.person",
        )
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
    NavigationStack {
        MovieList()
            .modelContainer(SampleData.shared.modelContainer)
    }
}

#Preview("Filtered") {
    NavigationStack {
        MovieList(titleFilter: "tr")
            .modelContainer(SampleData.shared.modelContainer)
    }
}

#Preview("Empty movie list") {
    NavigationStack {
        MovieList()
            .modelContainer(
                for: Movie.self,
                inMemory: true,
            )
    }
}
