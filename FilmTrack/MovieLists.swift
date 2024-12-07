//
//  MovieLists.swift
//  FilmTrack
//
//  Created by Grace Landolfi on 12/6/24.
//

import Foundation

@Observable

class MovieLists {
    private struct Returned: Codable {
        var results: [Film]
        var page: Int
        var total_pages: Int
    }
    var isLoading = false
    var page = 1
    var pageSize = 20
    var urlString: String
    
    var movieListFilmsArray: [Film] = []
    
    init(category: MovieList) {
        self.urlString = "https://api.themoviedb.org/3/movie/\(category.rawValue)?api_key=c3cbb4185fe214b22ed53f597f3b5e5a&page="
    }
    
    func getData(for page: Int) async {
        guard page != 0 else { return }
        isLoading = true
        let urlWithSearch = urlString + String(page)
        print("We are accessing the url \(urlWithSearch)")
        
        //Create a URL
        guard let url = URL(string: urlWithSearch) else {
            print("ERROR: Could not create a URL from \(urlWithSearch)")
            isLoading = false
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("JSON ERROR: Could not return JSON data")
                isLoading = false
                return
            }
            
            if returned.results.isEmpty {
                print("No more films available.")
                isLoading = false
                return
            }
            
            movieListFilmsArray.append(contentsOf: returned.results)
            isLoading = false
            
            if returned.page >= returned.total_pages {
                self.page = 0
            } else {
                self.page += 1
            }
        } catch {
            print("ERROR: Could not get data from \(urlWithSearch)")
            isLoading = false
        }
    }
    
    func loadAll() async {
        guard page != 0 else {return}
        print("pageNumber = \(page)")
        
        await getData(for: page)
        if page != 0{
            await loadAll()
        }
    }
}
