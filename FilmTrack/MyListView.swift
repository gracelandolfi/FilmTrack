//
//  MyListView.swift
//  FilmTrack
//
//  Created by Grace Landolfi on 11/28/24.
//

import SwiftUI
import SwiftData

enum Status: String, CaseIterable {
    case all = "All Films"
    case thumbsUp = "Thumbs Up"
    case thumbsDown = "Thumbs Down"
}

struct SortedMyListView: View {
    @Query var myList: [MyList]
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    let statusSelection: Status
    
    
    init(statusSelection: Status) {
        self.statusSelection = statusSelection
        switch self.statusSelection {
        case .all:
            _myList = Query()
        case .thumbsUp:
            _myList = Query(filter: #Predicate{$0.thumbsUp == true})
        case .thumbsDown:
            _myList = Query(filter: #Predicate{$0.thumbsDown == true})
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(myList) { film in
                    HStack {
                        NavigationLink {
                            MyListDetailView(myListItem: film)
                        } label: {
                            HStack {
                                Text(film.original_title)
                                
                                Spacer()
                                
                                if film.thumbsUp {
                                    Image(systemName: "hand.thumbsup.fill")
                                        .foregroundStyle(.green)
                                } else if film.thumbsDown {
                                    Image(systemName: "hand.thumbsdown.fill")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                modelContext.delete(film)
                                guard let _ = try? modelContext.save() else {
                                    print("ERROR: Save after .delete on ToDoListView did not work.")
                                    return
                                }
                            }
                        }
                    }
                    
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Film Search") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct MyListView: View {
    @State private var statusSelection: Status = .all
    
    var body: some View {
        NavigationStack {
            SortedMyListView(statusSelection: statusSelection)
                .navigationTitle("My List")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Picker("", selection: $statusSelection) {
                            Text("All Films")
                                .tag(Status.all)
                            
                            Image(systemName: "hand.thumbsup.fill")
                                .tag(Status.thumbsUp)
                                .foregroundStyle(.green)
                            
                            Image(systemName: "hand.thumbsdown.fill")
                                .tag(Status.thumbsDown)
                                .foregroundStyle(.red)
                        }
                        .pickerStyle(.segmented)
                    }
                }
        }
    }
}

#Preview {
    MyListView()
        .modelContainer(MyList.preview)
}
