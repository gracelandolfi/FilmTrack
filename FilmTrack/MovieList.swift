//
//  MovieList.swift
//  FilmTrack
//
//  Created by Grace Landolfi on 12/6/24.
//

import Foundation

enum MovieList: String, CaseIterable, Codable {
    case popular, top_rated, upcoming, now_playing
    
    var displayName: String {
            switch self {
            case .popular:
                return "Popular"
            case .top_rated:
                return "Top Rated"
            case .upcoming:
                return "Upcoming"
            case .now_playing:
                return "Now Playing"
            }
        }
}
