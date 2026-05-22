//
//  FilteredFriendList.swift
//  FriendsFavoriteMovies
//
//  Created by Felipe Eduardo Campelo Ferreira Osorio on 03/05/26.
//

import SwiftUI
import SwiftData

struct FilteredFriendList: View {
    
    // MARK: - Properties
    
    @State private var searchString: String = ""
    
    // MARK: - Body
    
    var body: some View {
        NavigationSplitView {
            searchableFriendList
        } detail: {
            defaultDetailLink
        }
    }
    
    // MARK: - Subviews
    
    private var searchableFriendList: some View {
        FriendList(
            nameFilter: searchString
        )
        .searchable(text: $searchString)
    }
    
    private var defaultDetailLink: some View {
        Text("Select a friend")
            .navigationTitle("Friend")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Previews

#Preview {
    FilteredFriendList()
        .modelContainer(SampleData.shared.modelContainer)
}
