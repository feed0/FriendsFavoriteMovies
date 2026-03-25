//
//  FriendList.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 24/03/26.
//

import SwiftUI

import SwiftData

struct FriendList: View {
    @Query(sort: \Friend.name) private var friends: [Friend]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        List {
            ForEach(friends) { friend in
                Text(friend.name)
            }
        }
    }
}

#Preview {
    FriendList()
        .modelContainer(SampleData.shared.modelContainer)
}
