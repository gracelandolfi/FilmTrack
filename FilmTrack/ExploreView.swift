//
//  ExploreView.swift
//  FilmTrack
//
//  Created by Grace Landolfi on 11/28/24.
//

import SwiftUI

struct ExploreView: View {
    @State var topRatedFilms = TopRatedFilms()
    @State private var rank = 1
    @Environment(\.dismiss) var dismiss
    @State private var selectedFilm: Film? = nil
    @State private var translatedTitle = ""
    @State private var showTranslationMessage = false
    @State private var isTranslateButtonPressed = false
    private let translationMessage = "Click film title to translate."
    
    var body: some View {
        NavigationStack {
            List(topRatedFilms.topRatedFilmsArray, id: \.self) {film in
                NavigationLink {
                    FilmDetailView(film: film.asFilm)
                } label: {
                    VStack {
                        Text(film.original_title)
                            .font(.custom("BebasNeue", size: 20))
                            .multilineTextAlignment(.center)
                            .onTapGesture {
                                if isTranslateButtonPressed {
                                    selectedFilm = film.asFilm
                                }
                            }
                            .translationPresentation(
                                isPresented: .constant( selectedFilm == film.asFilm),
                                text: film.original_title)
                        
                        Spacer().frame(height: 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .task {
                if topRatedFilms.topRatedFilmsArray.isEmpty {
                    await topRatedFilms.getData(for: 1)
                }
            }
            
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Load All Popular Films") {
                        Task {
                            await topRatedFilms.loadAll()
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
            .navigationTitle("Explore Popular Films")
        }
        .alert(translationMessage, isPresented: $showTranslationMessage) {
            Button("Ok", role: .cancel) {
                showTranslationMessage.toggle()
            }
        }
    }

}

#Preview {
    ExploreView()
}
