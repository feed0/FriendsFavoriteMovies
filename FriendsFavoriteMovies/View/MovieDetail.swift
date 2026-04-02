//
//  MovieDetail.swift
//  FriendsFavoriteMovies
//
//  Created by Feed0 on 01/04/26.
//

import SwiftUI

struct MovieDetail: View {
    @Bindable var movie: Movie
    
    // MARK: - Body
    
    var body: some View {
        Form {
            movieTextField
            releaseDatePicker
        }
    }
    
    // MARK: - Subviews
    
    private var movieTextField: some View {
        TextField(
            "Movie title",
            text: $movie.title
        )
    }
    
    private var releaseDatePicker: some View {
        DatePicker(
            "Release date",
            selection: $movie.releaseDate,
            displayedComponents: .date
        )
    }
}

#Preview {
    MovieDetail(movie: SampleData.shared.movie)
}
