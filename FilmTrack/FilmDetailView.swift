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
            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    Text(film.original_title)
                        .multilineTextAlignment(.center)
                        .font(.custom("BebasNeue", size: 50))
                        .foregroundStyle(.red)
                        .minimumScaleFactor(0.5)
                    
                    Text(formatReleaseDate(releaseDate: film.release_date))
                        .font(.custom("BebasNeue", size: 30))
                        .foregroundStyle(.red).opacity(0.75)
                    
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
                        .font(.title2)
                        .padding()
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Film Search") {
                                    dismiss()
                                }
                                .foregroundStyle(.red)
                                .font(.custom("BebasNeue", size: 20))
                            }
                            
                        
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    addToMyList()
                                } label: {
                                    Image(systemName: "plus")
                                    Text("Add to My List")
                                }
                                .foregroundStyle(.red)
                                .font(.custom("BebasNeue", size: 20))
                            }
                        }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
    
    func addToMyList() {
        let myListItem = MyList(original_title: film.original_title, overview: film.overview, poster_path: film.poster_path ?? "", release_date: film.release_date, reviews: "")
        
        modelContext.insert(myListItem)
        
        guard let _ = try? modelContext.save() else {
            print("ERROR: Save did not work.")
            return
        }
        dismiss()
    }
}

#Preview {
    FilmDetailView(film: Film(original_title: "Moana", overview: "In Ancient Polynesia, when a terrible curse incurred by Maui reaches the island of an impetuous Chieftain, his willful daughter answers the Ocean's call to seek out the demigod to set things right.  Live-action adaptation of the 2016 Disney animated film 'Moana'", release_date: "2026-07-09"))
}
