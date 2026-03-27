//
//  FriendList.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 24/03/26.
//

import SwiftUI
import SwiftData

struct FriendList: View {
    
    // MARK: - Subviews
    
    @Query(sort: \Friend.name) private var friends: [Friend]
    
    @Environment(\.modelContext) private var context
    
    // MARK: - Subviews
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(friends) { friend in
                    NavigationLink(friend.name) {
                        friendDetailLink(for: friend)
                    }
                }
            }
            .navigationTitle("Friends")
        } detail: {
            defaultDetailLink
        }
    }
    
    // MARK: - Subviews
    
    private func friendDetailLink(for friend: Friend) -> some View {
        Text("Detail view for \(friend.name)")
            .navigationTitle("Friend")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private var defaultDetailLink: some View {
        Text("Select a friend")
            .navigationTitle("Friend")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FriendList()
        .modelContainer(SampleData.shared.modelContainer)
}
