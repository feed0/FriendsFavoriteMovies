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
                        friendDetail(for: friend)
                    }
                }
                .onDelete(perform: deleteFriends(indexes:))
            }
            .navigationTitle("Friends")
            .toolbar {
                ToolbarItem {
                    addFriendButton
                }
                ToolbarItem {
                    EditButton()
                }
            }
        } detail: {
            defaultDetailLink
        }
    }
    
    // MARK: - Subviews
    
    private func friendDetail(for friend: Friend) -> some View {
        FriendDetail(friend: friend)
    }
    
    private var addFriendButton: some View {
        Button(
            "Add friend",
            systemImage: "plus",
            action: addFriend
        )
    }
    
    private var defaultDetailLink: some View {
        Text("Select a friend")
            .navigationTitle("Friend")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Private funcs
    
    private func addFriend() {
        let newFriend = Friend(name: "New friend")
        context.insert(newFriend)
    }
    
    private func deleteFriends(indexes: IndexSet) {
        for index in indexes {
            context.delete(friends[index])
        }
    }
}

#Preview {
    FriendList()
        .modelContainer(SampleData.shared.modelContainer)
}
