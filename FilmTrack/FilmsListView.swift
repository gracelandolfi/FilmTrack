//
//  ContentView.swift
//  FilmTrack
//
//  Created by Grace Landolfi on 11/28/24.
//

import SwiftUI
import FirebaseAuth

struct FilmsListView: View {
    @State var films = Films()
    @State var searchText = ""
    @State private var isExploreSheetPresented = false
    @State private var isMyListSheetPresented = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            NavigationStack {
                List(films.filmsArray, id: \.self) {film in
                    NavigationLink {
                        FilmDetailView(film: film)
                    } label: {
                        VStack {
                            Text(film.original_title)
                                .font(.title2)
                                .multilineTextAlignment(.center)
                            
                            Spacer().frame(height: 10)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .listStyle(.plain)
                .onChange(of: searchText) {
                    Task {
                        await films.getData(for: searchText)
                    }
                }
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
                }
            }
            .searchable(text: $searchText)
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

#Preview {
    FilmsListView()
        .modelContainer(MyList.preview)
}
