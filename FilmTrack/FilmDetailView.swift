//
//  FilmDetailView.swift
//  FilmTrack
//
//  Created by Grace Landolfi on 11/28/24.
//

import SwiftUI
import SwiftData

struct FilmDetailView: View {
    let film: Film
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            
            Text(film.original_title)
                .font(.largeTitle)
                .bold()
                .minimumScaleFactor(0.5)
            
            Text(film.release_date)
            
            Spacer()
            
            
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/original/\(film.poster_path ?? "")")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            } placeholder: {
                ProgressView()
            }
            
            Spacer()
            
            Text(film.overview)
                .padding()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            addToMyList()
                        } label: {
                            Image(systemName: "plus")
                            Text("Add to My List")
                        }
                        
                    }
                }
        }
    }
    
    func addToMyList() {
        let myListItem = MyList(original_title: film.original_title, overview: film.overview, poster_path: film.poster_path ?? "", backdrop_path: film.backdrop_path ?? "", original_language: film.release_date, release_date: film.original_language, reviews: "")
        
        modelContext.insert(myListItem)
        
        guard let _ = try? modelContext.save() else {
            print("ERROR: Save did not work.")
            return
        }
        dismiss()
    }
}

#Preview {
    FilmDetailView(film: Film(original_title: "Test", overview: "Test", original_language: "Test", release_date: "Test"))
}
