//
//  CastOrCrewMemberList.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 25/05/26.
//

import SwiftUI
import SwiftData

struct CastOrCrewMemberList: View {
    
    // MARK: - Properties
    
    @Environment(\.modelContext) private var context
    
    @Query(sort: \CastOrCrewMember.name) private var members: [CastOrCrewMember]
    @State private var newMember: CastOrCrewMember?
    
    // MARK: - Init
    
    init(
        nameFilter: String = ""
    ) {
        let predicate = #Predicate<CastOrCrewMember> { member in
            nameFilter.isEmpty
            || member.name.localizedStandardContains(nameFilter)
        }
        
        _members = Query(
            filter: predicate,
            sort: \CastOrCrewMember.name,
        )
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if !members.isEmpty {
                List {
                    ForEach(members) { member in
                        NavigationLink(member.name) {
                            castOrCrewMemberDetail(for: member)
                        }
                    }
                    .onDelete(perform: deleteMembers(indexes:))
                }
            } else {
                contentUnavailableView
            }
        }
        .navigationTitle("Cast & Crew")
        .toolbar {
            ToolbarItem {
                addMemberButton
            }
            ToolbarItem {
                editButton
            }
        }
        .sheet(item: $newMember) { member in
            NavigationStack {
                newMemberDetail(for: member)
            }
            .interactiveDismissDisabled()
        }
    }
    
    // MARK: - Subviews
    
    // MARK: toolbar
    
    private var addMemberButton: some View {
        Button(
            "Add member",
            systemImage: "plus",
            action: addMember
        )
    }
    
    private var editButton: some View {
        EditButton()
    }
    
    // MARK: sheets
    
    private func castOrCrewMemberDetail(for member: CastOrCrewMember) -> some View {
        CastOrCrewMemberDetail(for: member)
    }
    
    private func newMemberDetail(for member: CastOrCrewMember) -> some View {
        CastOrCrewMemberDetail(
            for: member,
            isNew: true
        )
    }
    
    // MARK: other
    
    private var contentUnavailableView: some View {
        ContentUnavailableView(
            "Add cast or crew members",
            systemImage: "person.3.fill",
        )
    }
    
    // MARK: - Private funcs
    
    private func addMember() {
        let newMember = CastOrCrewMember(name: "", role: "")
        context.insert(newMember)
        self.newMember = newMember
    }
    
    private func deleteMembers(indexes: IndexSet) {
        for index in indexes {
            context.delete(members[index])
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        CastOrCrewMemberList()
            .modelContainer(SampleData.shared.modelContainer)
    }
}

#Preview("Filtered") {
    NavigationStack {
        CastOrCrewMemberList(
            nameFilter: "Ali",
        )
        .modelContainer(SampleData.shared.modelContainer)
    }
}

#Preview("Empty cast list") {
    NavigationStack {
        CastOrCrewMemberList()
            .modelContainer(
                for: CastOrCrewMember.self,
                inMemory: true,
            )
    }
}
