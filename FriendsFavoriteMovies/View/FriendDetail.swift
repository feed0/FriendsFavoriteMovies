//
//  FriendDetail.swift
//  FriendsFavoriteMovies
//
//  Created by Feed0 on 01/04/26.
//

import SwiftUI
import SwiftData

struct FriendDetail: View {
    @Bindable var friend: Friend
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    // MARK: - Body
    
    var body: some View {
        Form {
            friendTextField
        }
        .navigationTitle("Friend")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                saveButton
            }
            ToolbarItem(placement: .cancellationAction) {
                cancelButton
            }
        }
    }
    
    // MARK: - Subviews
    
    private var friendTextField: some View {
        TextField(
            "Name",
            text: $friend.name
        )
        .autocorrectionDisabled()
    }
    
    private var saveButton: some View {
        Button("Save") {
            handleSaveButton()
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            handleCancelButton()
        }
    }
    
    // MARK: - Private funcs
    
    private func handleSaveButton() {
        dismiss()
    }
    
    private func handleCancelButton() {
        context.delete(friend)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        FriendDetail(friend: SampleData.shared.friend)
    }
}
