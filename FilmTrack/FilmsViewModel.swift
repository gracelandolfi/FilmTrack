//
//  FilmsViewModel.swift
//  FilmTrack
//
//  Created by Grace Landolfi on 11/28/24.
//

import Foundation

@Observable

class FilmsViewModel {
    struct Returned: Codable {
        var results: [Film]
    }
    
    var urlString = "https://api.themoviedb.org/3/search/movie?api_key=c3cbb4185fe214b22ed53f597f3b5e5a&query="
    var filmsArray: [Film] = []
    
    func getData(for searchValue: String) async {
        let urlWithSearch = urlString + searchValue
        print("We are accessing the url \(urlWithSearch)")
        
        guard let url = URL(string: urlWithSearch) else {
            print("ERROR: Could not create a URL from \(urlWithSearch)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("JSON ERROR: Could not return JSON data")
                return
            }
            
            self.filmsArray = returned.results
        } catch {
            print("ERROR: Could not get data from \(urlWithSearch)")
        }
    }
    
}
