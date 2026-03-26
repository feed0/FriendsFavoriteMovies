//
//  MovieList.swift
//  FriendsFavoriteMovies
//
//  Created by Felipe Campelo on 25/03/26.
//

import SwiftUI
import SwiftData

struct MovieList: View {
    
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Movie.title) private var movies: [Movie]
    
    var body: some View {
        List {
            ForEach(movies) { movie in
                Text(movie.title)
            }
        }
    }
}

#Preview {
    MovieList()
        .modelContainer(SampleData.shared.modelContainer)
}
