//
//  MyList.swift
//  FilmTrack
//
//  Created by Grace Landolfi on 11/28/24.
//

import Foundation
import SwiftData

@Model

class MyList {
    var original_title: String
    var overview: String
    var poster_path: String
    var release_date: String
    var reviews: String
    var thumbsUp = false
    var thumbsDown = false
    
    init(original_title: String, overview: String, poster_path: String, release_date: String, reviews: String = "", thumbsUp: Bool = false, thumbsDown: Bool = false) {
        self.original_title = original_title
        self.overview = overview
        self.poster_path = poster_path
        self.release_date = release_date
        self.reviews = reviews
        self.thumbsUp = thumbsUp
        self.thumbsDown = thumbsDown
    }
    
    convenience init() {
        self.init(original_title: "", overview: "", poster_path: "", release_date: "", reviews: "", thumbsUp: false, thumbsDown: false)
    }
}

extension MyList {
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: MyList.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        Task { @MainActor in
            container.mainContext.insert(MyList(original_title: "Sing", overview: "Singing Animals", poster_path: "", release_date: "", reviews: "no notes", thumbsUp: true, thumbsDown: false))
            container.mainContext.insert(MyList(original_title: "Avengers", overview: "Superheros", poster_path: "", release_date: "", reviews: "", thumbsUp: false, thumbsDown: true))
            container.mainContext.insert(MyList(original_title: "Miracle", overview: "Hockey", poster_path: "", release_date: "", reviews: "", thumbsUp: false, thumbsDown: false))
        }
        
        return container
    }
}
