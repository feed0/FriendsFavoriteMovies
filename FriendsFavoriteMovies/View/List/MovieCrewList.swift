//
//  MovieCrewList.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 01/06/26.
//

import SwiftUI
import SwiftData

struct MovieCrewList: View {
    
    // MARK: - Properties
    
    @Bindable var movie: Movie
    private let memberFilter: String
    
    // MARK: Computed properties
    
    private var filteredMembers: [CastOrCrewMember] {
        guard !memberFilter.isEmpty else {
            return movie.castAndCrew
        }
        
        return movie.castAndCrew.filter {
            $0.name.localizedStandardContains(memberFilter)
            || $0.role.localizedStandardContains(memberFilter)
        }
    }
    
    private var isContentAvailable: Bool {
        !filteredMembers.isEmpty
    }
    
    // MARK: - Init
    
    init(
        movie: Movie,
        memberFilter: String = ""
    ) {
        self.movie = movie
        self.memberFilter = memberFilter
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if isContentAvailable {
                List {
                    ForEach(filteredMembers) { member in
                        HStack {
                            memberNameText(for: member)
                            Spacer()
                            memberRoleText(for: member)
                        }
                    }
                    .onDelete(perform: deleteMovieMemberRelationship(indexes:))
                }
            } else {
                contentUnavailableView
            }
        }
    }
    
    // MARK: - Subviews
    
    private func memberNameText(for member: CastOrCrewMember) -> some View {
        Text(member.name)
            .font(.body)
    }
    
    private func memberRoleText(for member: CastOrCrewMember) -> some View {
        Text(member.role)
            .font(.caption)
            .foregroundColor(.secondary)
    }
    
    private var contentUnavailableView: some View {
        ContentUnavailableView(
            "Add cast or crew members",
            systemImage: "person.3.fill"
        )
    }
    
    // MARK: - Functions
    
    private func deleteMovieMemberRelationship(indexes: IndexSet) {
        for index in indexes {
            let member = filteredMembers[index]
            if let memberIndex = movie.castAndCrew.firstIndex(where: { $0 === member }) {
                movie.castAndCrew.remove(at: memberIndex)
            }
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        MovieCrewList(movie: Movie.sampleData[0])
            .modelContainer(SampleData.shared.modelContainer)
    }
}
