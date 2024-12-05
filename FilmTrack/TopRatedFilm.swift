//
//  TopRatedFilm.swift
//  FilmTrack
//
//  Created by Grace Landolfi on 11/28/24.
//

import Foundation

struct TopRatedFilm: Codable, Hashable {
    var original_title: String
    var overview: String
    var poster_path: String?
    var release_date: String
    
    var asFilm: Film {
        return Film(original_title: original_title, overview: overview, poster_path: poster_path, release_date: release_date)
    }
}
