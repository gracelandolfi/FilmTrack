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
    
    var body: some View {
        NavigationStack {
            VStack {
                if showTranslationMessage {
                    HStack {
                        Image(systemName: "questionmark.circle")
                        Text("CLICK FILM TITLE TO TRANSLATE")
                    }
                }
                HStack {
                    TextField("Enter title...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, 10)
                        .frame(height: 40)
                        .focused($isFocused)
                    
                    
                    Button("Search") {
                        Task {
                            await films.getData(for: searchText)
                        }
                        isFocused = false
                    }
                    .buttonStyle(.bordered)
                    .padding(.trailing, 10)
                    .frame(height: 40)
                }
                .padding()
                
                List(films.filmsArray, id: \.self) {film in
                    NavigationLink {
                        FilmDetailView(film: film)
                    } label: {
                        VStack {
                            Text(film.original_title)
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .onTapGesture {
                                    selectedFilm = film
                                }
                                .translationPresentation(
                                    isPresented: .constant(selectedFilm == film),
                                    text: film.original_title,
                                    attachmentAnchor: .point(.top),
                                    arrowEdge: .bottom
                                ) { translatedText in
                                    translatedTitle = translatedText
                                    print("Translated text: \(translatedText)")
                                }
                            
                            Spacer().frame(height: 10)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Search Films")
                .fullScreenCover(isPresented: $isExploreSheetPresented) {
                    ExploreView()
                }
                .fullScreenCover(isPresented: $isMyListSheetPresented) {
                    MyListView()
                }
                .toolbar {
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
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showTranslationMessage.toggle()
                        } label: {
                            Image(systemName: "questionmark.circle")
                            Text("Translate")
                        }
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
                .buttonStyle(.borderedProminent)        }
        }
    }
}

#Preview {
    FilmsListView()
        .modelContainer(MyList.preview)
}
