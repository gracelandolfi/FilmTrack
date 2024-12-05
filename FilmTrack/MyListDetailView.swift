//
//  MyListDetailView.swift
//  FilmTrack
//
//  Created by Grace Landolfi on 11/28/24.
//

import SwiftUI

struct MyListDetailView: View {
    let myListItem: MyList
    //    let lineLimit = 3
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var reviews = ""
    @State var thumbsUp: Bool = false
    @State var thumbsDown: Bool = false
    
    var body: some View {
        HStack {
            
            Spacer()
            
            Button {
                myListItem.reviews = reviews
                myListItem.thumbsUp = thumbsUp
                myListItem.thumbsDown = thumbsDown
                
                guard let _ = try? modelContext.save() else {
                    print("ERROR: Save did not work.")
                    return
                }
                dismiss()
            } label: {
                Text("Save")
            }
            .font(.custom("BebasNeue", size: 20))
            .padding(.horizontal)
            .foregroundStyle(.red)
        }
        
        NavigationStack {
            VStack(alignment: .center, spacing: 10) {
                List {
                    Group{
                        Text(myListItem.original_title)
                            .font(.custom("BebasNeue", size: 50))
                            .foregroundStyle(.red)
                            .minimumScaleFactor(0.5)
                        
                        Text(formatReleaseDate(releaseDate: myListItem.release_date))
                            .font(.custom("BebasNeue", size: 30))
                            .foregroundStyle(.red).opacity(0.75)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
                    
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/original/\(myListItem.poster_path)")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text(myListItem.overview)
                        .listRowSeparator(.hidden)
                        .font(.title2)
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Review")
                            .font(.custom("BebasNeue", size: 20))
                            .foregroundStyle(.red)
                        TextField("Enter Review", text: $reviews, axis: .vertical)
                    }
                    
                    .listStyle(.plain)
                    .onAppear() {
                        reviews = myListItem.reviews
                        thumbsUp = myListItem.thumbsUp
                        thumbsDown = myListItem.thumbsDown
                    }
                }
                .listStyle(.plain)
                .padding(.horizontal)
                .navigationBarBackButtonHidden()
            }
        }
        HStack {
            Button {
                thumbsDown = true
                thumbsUp = false
            } label: {
                Image(systemName: "hand.thumbsdown.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(thumbsDown ? .red : .gray)
            }
            
            Spacer()
            
            Button {
                thumbsUp = true
                thumbsDown = false
            } label: {
                Image(systemName: "hand.thumbsup.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(thumbsUp ? .green : .gray)
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        MyListDetailView(myListItem: MyList(original_title: "Moana", overview: "In Ancient Polynesia, when a terrible curse incurred by Maui reaches the island of an impetuous Chieftain, his willful daughter answers the Ocean's call to seek out the demigod to set things right.  Live-action adaptation of the 2016 Disney animated film 'Moana'", poster_path: "/ys0jZr0quHERDUEoCboGQEKPvgQ.jpg", release_date: "2026-07-09", reviews: "", thumbsUp: false, thumbsDown: false))
    }
}
