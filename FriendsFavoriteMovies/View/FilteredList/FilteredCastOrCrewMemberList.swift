//
//  FilteredCastOrCrewMemberList.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 25/05/26.
//

import SwiftUI
import SwiftData

struct FilteredCastOrCrewMemberList: View {
    
    // MARK: - Properties
    
    @State private var searchString: String = ""
    
    // MARK: - Body
    
    var body: some View {
        NavigationSplitView {
            searchableList
        } detail: {
            defaultDetailLink
        }
    }
    
    // MARK: - Subviews
    
    private var searchableList: some View {
        CastOrCrewMemberList(
            nameFilter: searchString
        )
        .searchable(text: $searchString)
    }
    
    private var defaultDetailLink: some View {
        Text("Select a cast or crew member")
            .navigationTitle("Cast & Crew")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Previews

#Preview {
    FilteredCastOrCrewMemberList()
        .modelContainer(SampleData.shared.modelContainer)
}
