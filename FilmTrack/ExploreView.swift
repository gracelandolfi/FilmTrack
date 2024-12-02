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
                ToolbarItem(placement: .principal) {
                    Text("Explore Popular Films")
                        .font(.custom("BebasNeue", size: 30))
                        .foregroundStyle(.red)
                }
                
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
            }
        }
    }

}

#Preview {
    ExploreView()
}
