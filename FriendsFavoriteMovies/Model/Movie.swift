//
//  Movie.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 23/03/26.
//

import Foundation
import SwiftData

@Model
class Movie {
    var title: String
    var releaseDate: Date
    
    init(title: String, releaseDate: Date) {
        self.title = title
        self.releaseDate = releaseDate
    }
}
