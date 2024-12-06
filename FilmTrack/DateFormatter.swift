//
//  DateFormatter.swift
//  FilmTrack
//
//  Created by Grace Landolfi on 12/5/24.
//

import Foundation

func formatReleaseDate(releaseDate: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let date = dateFormatter.date(from: releaseDate) {
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    } else {
        return releaseDate
    }
}
