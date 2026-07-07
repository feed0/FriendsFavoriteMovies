//
//  CrewMemberPicker.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 01/06/26.
//

import SwiftUI
import SwiftData

struct CrewMemberPicker: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss

    @Query(sort: \CastOrCrewMember.name) private var members: [CastOrCrewMember]
    @State private var searchString: String = ""
    @State private var selectedMembers: [CastOrCrewMember]
    private let currentMembers: [CastOrCrewMember]

    var onSave: ([CastOrCrewMember]) -> Void

    // MARK: - Init

    init(
        currentMembers: [CastOrCrewMember] = [],
        onSave: @escaping ([CastOrCrewMember]) -> Void
    ) {
        self.currentMembers = currentMembers
        self.onSave = onSave
        _selectedMembers = State(initialValue: currentMembers)
    }

    // MARK: - Body

    var body: some View {
        Group {
            if !filteredMembers.isEmpty {
                List {
                    ForEach(filteredMembers) { member in
                        Button {
                            toggleSelection(for: member)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    memberNameText(for: member)
                                    memberRoleText(for: member)
                                }
                                Spacer()
                                if isMemberSelected(member) {
                                    checkmarkIcon
                                }
                            }
                            .foregroundStyle(isMemberInCurrentParticipations(member) ? .secondary : .primary)
                        }
                        .disabled(isMemberInCurrentParticipations(member))
                    }
                }
            } else {
                ContentUnavailableView(
                    "No members found",
                    systemImage: "person.crop.circle.badge.questionmark"
                )
            }
        }
        .searchable(text: $searchString)
        .navigationTitle("Select Member")
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

    private func memberNameText(for member: CastOrCrewMember) -> some View {
        Text(member.name)
    }

    private func memberRoleText(for member: CastOrCrewMember) -> some View {
        Text(member.role)
            .font(.caption)
            .foregroundColor(.secondary)
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
        onSave(selectedMembers)
        dismiss()
    }

    private func toggleSelection(for member: CastOrCrewMember) {
        guard !isMemberInCurrentParticipations(member) else { return }

        if let index = selectedMembers.firstIndex(where: { $0 === member }) {
            selectedMembers.remove(at: index)
        } else {
            selectedMembers.append(member)
        }
    }

    private var filteredMembers: [CastOrCrewMember] {
        guard !searchString.isEmpty else { return members }
        return members.filter {
            $0.name.localizedStandardContains(searchString) || $0.role.localizedStandardContains(searchString)
        }
    }

    // MARK: - Helpers

    private func isMemberSelected(_ member: CastOrCrewMember) -> Bool {
        selectedMembers.contains(where: { $0 === member })
    }

    private func isMemberInCurrentParticipations(_ member: CastOrCrewMember) -> Bool {
        currentMembers.contains(where: { $0 === member })
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        CrewMemberPicker(currentMembers: CastOrCrewMember.sampleData) { _ in }
            .modelContainer(SampleData.shared.modelContainer)
    }
}

#Preview("Empty members") {
    NavigationStack {
        CrewMemberPicker { _ in }
    }
}
