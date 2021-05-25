//
//  MovieInfo.swift
//  MovieBrowser
//
//  Created by Sandhya Mali on 5/22/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation

struct MovieInfo  {

    var posterPath:String
    var overview:String
    var releaseDate:String
    var title:String
    var voteAverage:Double

    init(posterPath:String, overview:String, releaseDate:String, title:String, voteAverage:Double) {
        self.posterPath = posterPath
        self.overview = overview
        self.releaseDate = releaseDate
        self.title = title
        self.voteAverage = voteAverage
    }
    
    static func parseMovieInfoFrom(response: [[String:Any]]) -> [MovieInfo]{
        var parsedMovieArray:[MovieInfo] = []
        
        response.forEach{
            var parsedMovie = MovieInfo(posterPath: "", overview: "", releaseDate: "", title: "", voteAverage: 0.0)
            parsedMovie.title = ($0[MovieAPI.titleKey] as? String) ?? ""
            parsedMovie.posterPath = ($0[MovieAPI.posterPathKey] as? String) ?? ""
            parsedMovie.overview = ($0[MovieAPI.overviewKey]) as? String ?? ""
            parsedMovie.voteAverage = ($0[MovieAPI.voteAverageKey]) as? Double ?? 0.0
            
            if let releaseDate = $0[MovieAPI.releaseDateKey] as? String{
                let dateArray = releaseDate.split(separator: "-")
                if dateArray.count == 3{
                    let date = "\(dateArray[1])/\(dateArray[2])/\(dateArray[0])"
                    parsedMovie.releaseDate = date
                }
            }
             
            parsedMovieArray.append(parsedMovie)
        }
        return parsedMovieArray
    }
}
