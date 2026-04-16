//
//  MovieDetail.swift
//  FriendsFavoriteMovies
//
//  Created by Feed0 on 01/04/26.
//

import SwiftUI
import SwiftData

struct MovieDetail: View {
    @Bindable var movie: Movie
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    // MARK: - Body
    
    var body: some View {
        Form {
            movieTextField
            releaseDatePicker
        }
        .navigationTitle("Movie")
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
        MovieDetail(movie: SampleData.shared.movie)
    }
}
