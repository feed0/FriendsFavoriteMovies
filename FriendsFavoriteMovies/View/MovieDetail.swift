//
//  MovieDetail.swift
//  FriendsFavoriteMovies
//
//  Created by Feed0 on 01/04/26.
//

import SwiftUI
import SwiftData

struct MovieDetail: View {
    
    // MARK: - Properties
    
    @Bindable var movie: Movie
    let isNew: Bool
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    // MARK: Computed properties
    
    private var navigationTitle: String {
        isNew ? "New Movie" : "Movie"
    }
    
    // MARK: - Init
    
    init(movie: Movie, isNew: Bool = false) {
        self.movie = movie
        self.isNew = isNew
    }
    
    // MARK: - Body
    
    var body: some View {
        Form {
            movieTextField
            releaseDatePicker
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
    
    private var movieTextField: some View {
        TextField(
            "Movie title",
            text: $movie.title
        )
    }
    
    private var releaseDatePicker: some View {
        DatePicker(
            "Release date",
            selection: $movie.releaseDate,
            displayedComponents: .date
        )
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
        context.delete(movie)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        MovieDetail(
            movie: SampleData.shared.movie
        )
    }
}

#Preview("New Movie") {
    NavigationStack {
        MovieDetail(
            movie: SampleData.shared.movie,
            isNew: true
        )
    }
}
