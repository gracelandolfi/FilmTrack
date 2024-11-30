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
    @State var thumbsUp = false
    @State var thumbsDown = false
    //    @State private var showEntireContent: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Group{
                    Text(myListItem.original_title)
                        .font(.largeTitle)
                        .bold()
                        .minimumScaleFactor(0.5)
                    
                    Text(myListItem.release_date)
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
                //                    .lineLimit(showEntireContent ? nil : lineLimit)
                    .listRowSeparator(.hidden)
                
                //                if !showEntireContent {
                //                    Button {
                //                        withAnimation {
                //                            showEntireContent = true
                //                        }
                //                    } label: {
                //                        Text("Expand description")
                //                            .foregroundStyle(.blue)
                //                    }
                //                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Review")
                        .font(.headline)
                    TextField("Enter Review", text: $reviews, axis: .vertical)
                }
                
                Spacer()
                
                HStack {
                    Button {
                        if thumbsDown {
                            thumbsDown = false
                        } else {
                            thumbsDown = true
                            thumbsUp = false
                        }
                        print("Thumbs Down")
                    } label: {
                        Image(systemName: "hand.thumbsdown.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(thumbsDown ? .red : .gray)
                    }
                    
                    Spacer()
                    
                    Button {
                        if thumbsUp {
                            thumbsUp = false
                        } else {
                            thumbsUp = true
                            thumbsDown = false
                        }
                        print("Thumbs Up")
                    } label: {
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(thumbsUp ? .green : .gray)
                    }
                }
                
                .listStyle(.plain)
                .onAppear() {
                    reviews = myListItem.reviews
                    thumbsUp = myListItem.thumbsUp
                    thumbsDown = myListItem.thumbsDown
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Back") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
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
                        
                    }
                }
                .navigationBarBackButtonHidden()
            }
            .listStyle(.plain)
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        MyListDetailView(myListItem: MyList(original_title: "", overview: "", poster_path: "", backdrop_path: "", original_language: "", release_date: "", reviews: "", thumbsUp: false, thumbsDown: false))
    }
}
