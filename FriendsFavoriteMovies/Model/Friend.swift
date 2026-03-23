//
//  Friend.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 23/03/26.
//

import Foundation
import SwiftData

@Model
class Friend {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
