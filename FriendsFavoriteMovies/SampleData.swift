//
//  SampleData.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 24/03/26.
//

import Foundation
import SwiftData

@MainActor
class SampleData {
    
    // MARK: - Properties
    
    static let shared = SampleData()
    
    let modelContainer: ModelContainer
    
    // MARK: Computed properties
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    // MARK: - Init
    
    private init() {
        let schema = Schema([
            Friend.self,
            Movie.self,
            CastOrCrewMember.self,
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true,
        )
        
        do {
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration],
            )
            
            insertSampleData()
            
            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    // MARK: - Private funcs
    
    private func insertSampleData() {
        /// Friends
        for friend in Friend.sampleData {
            context.insert(friend)
        }
        
        /// Movies
        for movie in Movie.sampleData {
            context.insert(movie)
        }
        
        /// Cast & Crew
        for member in CastOrCrewMember.sampleData {
            context.insert(member)
        }
        
        /// Link cast-&-crew to movies
        Movie.sampleData[0].castAndCrew.append(CastOrCrewMember.sampleData[0])
        Movie.sampleData[0].castAndCrew.append(CastOrCrewMember.sampleData[1])
        CastOrCrewMember.sampleData[0].movies.append(Movie.sampleData[0])
        CastOrCrewMember.sampleData[0].movies.append(Movie.sampleData[1])
        CastOrCrewMember.sampleData[0].movies.append(Movie.sampleData[2])
        CastOrCrewMember.sampleData[1].movies.append(Movie.sampleData[0])
        
        /// Many-friends to One-movie
        Friend.sampleData[0].favoriteMovie = Movie.sampleData[1]
        Friend.sampleData[2].favoriteMovie = Movie.sampleData[0]
        Friend.sampleData[3].favoriteMovie = Movie.sampleData[4]
        Friend.sampleData[4].favoriteMovie = Movie.sampleData[0]
    }
}
