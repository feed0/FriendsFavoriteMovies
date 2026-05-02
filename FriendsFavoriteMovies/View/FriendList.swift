//
//  FriendList.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 24/03/26.
//

import SwiftUI
import SwiftData

struct FriendList: View {
    
    // MARK: - Properties
    
    @Query(sort: \Friend.name) private var friends: [Friend]
    
    @Environment(\.modelContext) private var context
    
    @State private var newFriend: Friend?
    
    // MARK: - Body
    
    var body: some View {
        NavigationSplitView {
            Group {
                if !friends.isEmpty {
                    List {
                        ForEach(friends) { friend in
                            NavigationLink(friend.name) {
                                friendDetail(for: friend)
                            }
                        }
                        .onDelete(perform: deleteFriends(indexes:))
                    }
                } else {
                    contentUnavailableView
                }
            }
            .navigationTitle("Friends")
            .toolbar {
                ToolbarItem {
                    addFriendButton
                }
                ToolbarItem {
                    editButton
                }
            }
            .sheet(item: $newFriend) { friend in
                NavigationStack {
                    newFriendDetail(for: friend)
                }
                .interactiveDismissDisabled()
            }
        } detail: {
            defaultDetailLink
        }
    }
    
    // MARK: - Subviews
    
    // MARK: toolbar
    
    private var addFriendButton: some View {
        Button(
            "Add friend",
            systemImage: "plus",
            action: addFriend
        )
    }
    
    private var editButton: some View {
        EditButton()
    }
    
    // MARK: sheets
    
    private func friendDetail(for friend: Friend) -> some View {
        FriendDetail(friend: friend)
    }
    
    private func newFriendDetail(for friend: Friend) -> some View {
        FriendDetail(
            friend: friend,
            isNew: true
        )
    }
    
    // MARK: other
    
    private var defaultDetailLink: some View {
        Text("Select a friend")
            .navigationTitle("Friend")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private var contentUnavailableView: some View {
        ContentUnavailableView(
            "Add Friends",
            systemImage: "person.and.person",
        )
    }
    
    // MARK: - Private funcs
    
    private func addFriend() {
        let newFriend = Friend(name: "")
        context.insert(newFriend)
        self.newFriend = newFriend
    }
    
    private func deleteFriends(indexes: IndexSet) {
        for index in indexes {
            context.delete(friends[index])
        }
    }
}

// MARK: - Previews

#Preview {
    FriendList()
        .modelContainer(SampleData.shared.modelContainer)
}

#Preview("Empty friend list") {
    FriendList()
        .modelContainer(
            for: Friend.self,
            inMemory: true,
        )
}
