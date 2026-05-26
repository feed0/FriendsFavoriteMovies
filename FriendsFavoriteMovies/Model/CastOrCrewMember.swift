//
//  CastOrCrewMember.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 08/05/26.
//

import Foundation
import SwiftData

@Model
class CastOrCrewMember {
    
    // MARK: - Init
    
    init(
        name: String,
        role: String,
    ) {
        self.name = name
        self.role = role
    }
    
    // MARK: - Properties
    
    var name: String
    var role: String
    
    // MARK: Relationship properties
    
    var movies: [Movie] = []
}

// MARK: - Mock data

extension CastOrCrewMember {
    static let sampleData = [
        CastOrCrewMember(
            name: "Alice Actor",
            role: "Lead Actress"
        ),
        CastOrCrewMember(
            name: "Bob Director",
            role: "Director"
        ),
        CastOrCrewMember(
            name: "Junior",
            role: "FX3 enthusiast"
        ),
    ]
}
