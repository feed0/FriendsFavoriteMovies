//
//  FriendPicker.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 02/06/26.
//

import SwiftUI
import SwiftData

struct FriendPicker: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss

    @Query(sort: \Friend.name) private var friends: [Friend]
    @State private var searchString: String = ""
    @State private var selectedFriends: [Friend]
    private let currentFavorites: [Friend]

    var onSave: ([Friend]) -> Void

    // MARK: - Init

    init(
        currentFavorites: [Friend] = [],
        onSave: @escaping ([Friend]) -> Void
    ) {
        self.currentFavorites = currentFavorites
        self.onSave = onSave
        _selectedFriends = State(initialValue: currentFavorites)
    }

    // MARK: - Body

    var body: some View {
        Group {
            if !filteredFriends.isEmpty {
                List {
                    ForEach(filteredFriends) { friend in
                        Button {
                            toggleSelection(for: friend)
                        } label: {
                            HStack {
                                friendNameText(for: friend)
                                Spacer()
                                if isFriendSelected(friend) {
                                    checkmarkIcon
                                }
                            }
                            .foregroundStyle(isFriendInCurrentFavorites(friend) ? .secondary : .primary)
                        }
                        .disabled(isFriendInCurrentFavorites(friend))
                    }
                }
            } else {
                ContentUnavailableView(
                    "No friends found",
                    systemImage: "person.crop.circle.badge.questionmark"
                )
            }
        }
        .searchable(text: $searchString)
        .navigationTitle("Select Friend")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                cancelButton
            }
            ToolbarItem(placement: .confirmationAction) {
                saveButton
            }
        }
    }

    // MARK: - Subviews

    private func friendNameText(for friend: Friend) -> some View {
        Text(friend.name)
    }

    private var checkmarkIcon: some View {
        Image(systemName: "checkmark")
            .foregroundColor(.accentColor)
    }

    // MARK: Toolbar buttons

    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }

    private var saveButton: some View {
        Button("Save") {
            handleSaveButton()
        }
    }

    // MARK: - Functions

    private func handleSaveButton() {
        onSave(selectedFriends)
        dismiss()
    }

    private func toggleSelection(for friend: Friend) {
        guard !isFriendInCurrentFavorites(friend) else { return }

        if let index = selectedFriends.firstIndex(where: { $0 === friend }) {
            selectedFriends.remove(at: index)
        } else {
            selectedFriends.append(friend)
        }
    }

    private var filteredFriends: [Friend] {
        guard !searchString.isEmpty else { return friends }
        return friends.filter {
            $0.name.localizedStandardContains(searchString)
        }
    }

    // MARK: - Helpers

    private func isFriendSelected(_ friend: Friend) -> Bool {
        selectedFriends.contains(where: { $0 === friend })
    }

    private func isFriendInCurrentFavorites(_ friend: Friend) -> Bool {
        currentFavorites.contains(where: { $0 === friend })
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        FriendPicker(currentFavorites: Friend.sampleData) { _ in }
            .modelContainer(SampleData.shared.modelContainer)
    }
}

#Preview("Empty friends") {
    NavigationStack {
        FriendPicker { _ in }
            .modelContainer(SampleData.shared.modelContainer)
    }
}
