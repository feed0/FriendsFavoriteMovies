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
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    // MARK: - Init
    
    private init() {
        let schema = Schema([
            Friend.self,
            Movie.self,
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
        for friend in Friend.sampleData {
            context.insert(friend)
        }
    }
}
