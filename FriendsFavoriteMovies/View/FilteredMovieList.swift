//
//  FilteredMovieList.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 01/05/26.
//

import SwiftUI
import SwiftData

struct FilteredMovieList: View {
    
    // MARK: - Properties
    
    @State private var searchString: String = ""
    @State private var sortToggleByDate: Bool = false
    
    // MARK: Compute properties
    
    private var sortDescriptor: SortDescriptor<Movie> {
        if sortToggleByDate {
            SortDescriptor(
                \Movie.releaseDate,
                 order: .reverse,
            )
        } else {
            SortDescriptor(
                \Movie.title,
                 order: .forward,
            )
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationSplitView {
            searchableMovieList
                .toolbar {
                    ToolbarItem {
                        movieSortToggle
                    }
                }
        } detail: {
            defaultDetailLink
        }
    }
    
    // MARK: - Subviews
    
    private var searchableMovieList: some View {
        MovieList(
            titleFilter: searchString,
            sortBy: sortDescriptor,
        )
        .searchable(text: $searchString)
    }
    
    private var movieSortToggle: some View {
        Toggle(
            "Filter by date",
            isOn: $sortToggleByDate,
        )
    }
    
    private var defaultDetailLink: some View {
        Text("Select a movie")
            .navigationTitle("Movie")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Previews

#Preview {
    FilteredMovieList()
        .modelContainer(SampleData.shared.modelContainer)
}
