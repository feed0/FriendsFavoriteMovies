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
    
    // MARK: - Properties
    
    static let sampleData = [
        Friend(name: "Elena"),
        Friend(name: "Graham"),
        Friend(name: "Mayuri"),
        Friend(name: "Rich"),
        Friend(name: "Rody"),
    ]
    
    var name: String
    
    // MARK: - Init
    
    init(name: String) {
        self.name = name
    }
}
