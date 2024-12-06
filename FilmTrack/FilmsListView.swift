//
//  ContentView.swift
//  FilmTrack
//
//  Created by Grace Landolfi on 11/28/24.
//

import SwiftUI
import FirebaseAuth
import Translation

struct FilmsListView: View {
    @State var films = FilmsViewModel()
    @State var searchText = ""
    @State private var isExploreSheetPresented = false
    @State private var isMyListSheetPresented = false
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    @State private var selectedFilm: Film? = nil
    @State private var translatedTitle = ""
    @State private var showTranslationMessage = false
    @State private var isTranslateButtonPressed = false
    private let translationMessage = "Click film title to translate."
    
    @State private var searchTask: Task<Void, Never>? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Enter film title...", text: $searchText)
                        .font(.custom("BebasNeue", size: 20))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .frame(height: 10)
                        .focused($isFocused)
                        .onChange(of: searchText) { oldValue, newValue in
                            searchTask?.cancel()
                            searchTask = Task {
                                do {
                                    try await Task.sleep(for: .milliseconds(300))
                                    
                                    if Task.isCancelled { return }
                                    
                                    if searchText == newValue {
                                        await films.getData(for: newValue)
                                    }
                                } catch {
                                    if !Task.isCancelled {
                                        print("ERROR: \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                }
            
                List(films.filmsArray, id: \.self) {film in
                    NavigationLink {
                        FilmDetailView(film: film)
                    } label: {
                        VStack {
                            Text(film.original_title)
                                .multilineTextAlignment(.center)
                                .font(.custom("BebasNeue", size: 20))
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
                .listStyle(.plain)
                .fullScreenCover(isPresented: $isExploreSheetPresented) {
                    MovieListsView()
                }
                .fullScreenCover(isPresented: $isMyListSheetPresented) {
                    MyListView()
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("FilmTrack")
                            .font(.custom("BebasNeue", size: 40))
                            .foregroundStyle(.red)
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Sign Out") {
                            do {
                                try Auth.auth().signOut()
                                print("Log out successful!")
                                dismiss()
                            } catch {
                                print("ERROR: Could not sign out!")
                            }
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
                
                .onAppear {
                    if films.filmsArray.isEmpty && searchText.isEmpty {
                        Task {
                            await films.getData(for: "")
                        }
                    }
                }
                
                HStack {
                    Button("Explore Films") {
                        isExploreSheetPresented.toggle()
                    }
                    
                    Button("My List") {
                        isMyListSheetPresented.toggle()
                    }
                }
                .buttonStyle(.bordered)
                .foregroundStyle(.red)
            }
        }
        
        .alert(translationMessage, isPresented: $showTranslationMessage) {
            Button("Ok", role: .cancel) {
                showTranslationMessage.toggle()
            }
        }
        
        .autocorrectionDisabled()
        .font(.custom("BebasNeue", size: 20))
    }
}

#Preview {
        FilmsListView()
            .modelContainer(MyList.preview)
}
