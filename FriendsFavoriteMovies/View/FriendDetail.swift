//
//  FriendDetail.swift
//  FriendsFavoriteMovies
//
//  Created by Feed0 on 01/04/26.
//

import SwiftUI

struct FriendDetail: View {
    @Bindable var friend: Friend
    
    // MARK: - Body
    
    var body: some View {
        Form {
            friendTextField
        }
        .navigationTitle("Friend")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    // MARK: - Subviews
    
    private var friendTextField: some View {
        TextField(
            "Name",
            text: $friend.name
        )
        .autocorrectionDisabled()
    }
}

#Preview {
    NavigationStack {
        FriendDetail(friend: SampleData.shared.friend)
    }
}
