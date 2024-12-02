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
            .padding(.horizontal)
            .foregroundStyle(.red)
        }
        
        NavigationStack {
            List {
                Group{
                    Text(myListItem.original_title)
                        .font(.custom("BebasNeue", size: 50))
                        .bold()
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(.red)
                    
                    Text(myListItem.release_date)
                        .font(.custom("BebasNeue", size: 20))
                        .foregroundStyle(.secondary)
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
                
                Spacer()
                
                Text(myListItem.overview)
                    .listRowSeparator(.hidden)
                    .font(.custom("BebasNeue", size: 20)).opacity(0.75)
                
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
        MyListDetailView(myListItem: MyList(original_title: "Sing", overview: "Singing Animals", poster_path: "", backdrop_path: "", original_language: "", release_date: "2024-01-01", reviews: "", thumbsUp: false, thumbsDown: false))
    }
}
