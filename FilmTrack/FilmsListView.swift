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
    @State var films = Films()
    @State var searchText = ""
    @State private var isExploreSheetPresented = false
    @State private var isMyListSheetPresented = false
    @Environment(\.dismiss) var dismiss
    @State private var selectedFilm: Film? = nil
    @State private var translatedTitle = ""
    @FocusState private var isFocused: Bool
    @State private var showTranslationMessage = false
    
    @State private var searchTask: Task<Void, Never>? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                if showTranslationMessage {
                    HStack {
                        Image(systemName: "questionmark.circle")
                        Text("CLICK FILM TITLE TO TRANSLATE")
                            .font(.custom("BebasNeue", size: 15))
                    }
                    .transition(.opacity)
                }
                HStack {
                    TextField("Enter title...", text: $searchText)
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
                                .font(.custom("BebasNeue", size: 20))
                                .multilineTextAlignment(.center)
                                .onTapGesture {
                                    selectedFilm = film
                                }
                                .translationPresentation(
                                    isPresented: .constant(selectedFilm == film),
                                    text: film.original_title)
                            
                            Spacer().frame(height: 10)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .listStyle(.plain)
                //                .navigationTitle("Search Films")
                .fullScreenCover(isPresented: $isExploreSheetPresented) {
                    ExploreView()
                }
                .fullScreenCover(isPresented: $isMyListSheetPresented) {
                    MyListView()
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Search Films")
                            .font(.custom("BebasNeue", size: 50))
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
                            
                            Task {
                                try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
                                showTranslationMessage = false
                            }
                        } label: {
                            Text("Translate")
                        }
                        .foregroundStyle(.red)
                    }
                    
                }
                
                
                .onAppear {
                    Task {
                        await films.getData(for: "")
                    }
                }
                
                
                
                HStack {
                    Button("Explore Popular Films") {
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
        .autocorrectionDisabled()
        .font(.custom("BebasNeue", size: 20))
    }
}

#Preview {
    FilmsListView()
        .modelContainer(MyList.preview)
}
