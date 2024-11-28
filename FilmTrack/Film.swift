//
//  Film.swift
//  FilmTrack
//
//  Created by Grace Landolfi on 11/28/24.
//

import Foundation

struct Film: Codable, Hashable/*, Identifiable*/ {
//    @DocumentID var id: String?
    var original_title: String
    var overview: String
    var poster_path: String?
    var backdrop_path: String?
    var original_language: String
    var release_date: String
}
