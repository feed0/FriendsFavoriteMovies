//
//  CastOrCrewMemberDetail.swift
//  FriendsFavoriteMovies
//
//  Created by feed0 on 25/05/26.
//

import SwiftUI
import SwiftData

struct MoviePicker: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \Movie.title) private var movies: [Movie]
    @State private var searchString: String = ""
    @State private var selectedMovies: [Movie]
    private let currentMovieParticipations: [Movie]
    
    var selectedMember: CastOrCrewMember? = nil
    
    var onSave: ([Movie]) -> Void
    
    // MARK: - Init
    
    init(
        selectedMember: CastOrCrewMember? = nil,
        onSave: @escaping ([Movie]) -> Void
    ) {
        self.selectedMember = selectedMember
        self.onSave = onSave
        
        let initialMovies = selectedMember?.movies ?? []
        self.currentMovieParticipations = initialMovies
        _selectedMovies = State(initialValue: initialMovies)
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if !filteredMovies.isEmpty {
                List {
                    ForEach(filteredMovies) { movie in
                        Button {
                            toggleSelection(for: movie)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    movieTitleText(for: movie)
                                    movieReleaseDateText(for: movie)
                                }
                                Spacer()
                                if isMovieSelected(movie) {
                                    checkmarkIcon
                                }
                            }
                            .foregroundStyle(isMovieInCurrentParticipations(movie) ? .secondary : .primary)
                        }
                        .disabled(isMovieInCurrentParticipations(movie))
                    }
                }
            } else {
                ContentUnavailableView(
                    "No movies found",
                    systemImage: "arrow.backward",
                )
                
            }
        }
        .searchable(text: $searchString)
        .navigationTitle("Select Movie")
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
    
    private func movieTitleText(for movie: Movie) -> some View {
        Text(movie.title)
    }
    
    private func movieReleaseDateText(for movie: Movie) -> some View {
        Text(
            movie.releaseDate,
            style: .date
        )
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
        onSave(selectedMovies)
        dismiss()
    }
    
    private func toggleSelection(for movie: Movie) {
        guard !isMovieInCurrentParticipations(movie) else { return }
        
        if let index = selectedMovies.firstIndex(where: { $0 === movie }) {
            selectedMovies.remove(at: index)
        } else {
            selectedMovies.append(movie)
        }
    }
    
    private var filteredMovies: [Movie] {
        guard !searchString.isEmpty else { return movies }
        return movies.filter { $0.title.localizedStandardContains(searchString) }
    }
    
    // MARK: - Helpers
    
    private func isMovieSelected(_ movie: Movie) -> Bool {
        selectedMovies.contains(where: { $0 === movie })
    }
    
    private func isMovieInCurrentParticipations(_ movie: Movie) -> Bool {
        currentMovieParticipations.contains(where: { $0 === movie })
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        MoviePicker(
            selectedMember: CastOrCrewMember.sampleData[0],
        ) { _ in }
            .modelContainer(SampleData.shared.modelContainer)
    }
}

#Preview("Empty movies list") {
    NavigationStack {
        MoviePicker { _ in }
    }
}
