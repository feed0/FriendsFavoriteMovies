//
//  FriendDetail.swift
//  FriendsFavoriteMovies
//
//  Created by Feed0 on 01/04/26.
//

import SwiftUI
import SwiftData

struct FriendDetail: View {
    
    // MARK: - Properties
    
    @Bindable var friend: Friend
    
    private let isNew: Bool
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    // MARK: Computed properties
    
    private var navigationTitle: String {
        isNew ? "New Friend" : "Friend"
    }
    
    // MARK: - Init
    
    init(
        friend: Friend,
        isNew: Bool = false
    ) {
        self.friend = friend
        self.isNew = isNew
    }
    
    // MARK: - Body
    
    var body: some View {
        Form {
            friendTextField
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    saveButton
                }
                ToolbarItem(placement: .cancellationAction) {
                    cancelButton
                }
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

// MARK: - Previews

#Preview {
    NavigationStack {
        FriendDetail(
            friend: SampleData.shared.friend
        )
    }
}

#Preview("New Friend") {
    NavigationStack {
        FriendDetail(
            friend: SampleData.shared.friend,
            isNew: true
        )
    }
}
