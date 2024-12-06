//
//  ExploreView.swift
//  FilmTrack
//
//  Created by Grace Landolfi on 11/28/24.
//

import SwiftUI

struct MovieListsView: View {
    @State private var selectedCategory: MovieList = .top_rated
    @State var movieLists: MovieLists
    @Environment(\.dismiss) var dismiss
    @State private var selectedFilm: Film? = nil
    @State private var translatedTitle = ""
    @State private var showTranslationMessage = false
    @State private var isTranslateButtonPressed = false
    private let translationMessage = "Click film title to translate."
    init() {
        _movieLists = State(initialValue: MovieLists(category: .top_rated))  // Initialize with top_rated by default
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Select Movie Category", selection: $selectedCategory) {
                    ForEach(MovieList.allCases, id: \.self) { category in
                        Text(category.displayName).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                .onChange(of: selectedCategory) { newCategory in
                    // Update the urlString when the category changes
                    movieLists = MovieLists(category: newCategory)
                    movieLists.movieListFilmsArray.removeAll() // Clear previous results
                    Task {
                        await movieLists.getData(for: 1) // Reload data for the selected category
                    }
                }
                
                List(movieLists.movieListFilmsArray, id: \.self) {film in
                    NavigationLink {
                        FilmDetailView(film: film)
                    } label: {
                        VStack {
                            Text(film.original_title)
                                .font(.custom("BebasNeue", size: 20))
                                .multilineTextAlignment(.center)
                                .onTapGesture {
                                    if isTranslateButtonPressed {
                                        selectedFilm = film
                                    }
                                }
                                .translationPresentation(
                                    isPresented: .constant( selectedFilm == film),
                                    text: film.original_title)
                            
                            Spacer().frame(height: 10)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .task {
                    if movieLists.movieListFilmsArray.isEmpty {
                        await movieLists.getData(for: 1)
                    }
                }
                
                .listStyle(.plain)
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Load All Top Rated Films") {
                            Task {
                                await movieLists.loadAll()
                            }
                        }
                        .foregroundStyle(.red)
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Back") {
                            dismiss()
                        }
                        .foregroundStyle(.red)
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showTranslationMessage.toggle()
                            
                            isTranslateButtonPressed.toggle()
                        } label: {
                            Text(isTranslateButtonPressed ? "Translate: On" : "Translate: Off")
                        }
                        .foregroundStyle(.red)
                    }
                }
                .navigationTitle("Explore Films")
            }
        }
        .alert(translationMessage, isPresented: $showTranslationMessage) {
            Button("Ok", role: .cancel) {
                showTranslationMessage.toggle()
            }
        }
    }
}

#Preview {
    MovieListsView()
}
