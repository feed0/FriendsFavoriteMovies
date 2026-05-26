//
//  ContentView.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 23/03/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            Tab(
                "Friends",
                systemImage: "person.and.person"
            ) {
                FilteredFriendList()
            }
            
            Tab(
                "Movies",
                systemImage: "film.stack"
            ) {
                FilteredMovieList()
            }
            
            Tab(
                "Cast",
                systemImage: "person.3.fill"
            ) {
                FilteredCastOrCrewMemberList()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}
