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
    
    // MARK: - Body
    
    var body: some View {
        NavigationSplitView {
            MovieList(
                titleFilter: searchString,
            )
            .searchable(text: $searchString)
        } detail: {
            defaultDetailLink
        }
    }
    
    // MARK: - Subviews
    
    private var defaultDetailLink: some View {
        Text("Select a movie")
            .navigationTitle("Movie")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FilteredMovieList()
        .modelContainer(SampleData.shared.modelContainer)
}
