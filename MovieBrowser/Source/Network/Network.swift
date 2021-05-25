//
//  Network.swift
//  SampleApp
//
//  Created by Struzinski, Mark - Mark on 9/17/20.
//  Copyright © 2020 Lowe's Home Improvement. All rights reserved.
//

import UIKit

typealias NetworkResponseHandler = (_ movieInfoList: [MovieInfo]?, _ errorString: String)-> Void

class Network {
    
    func downloadMovieInfo(searchPhrase:String, responseHandler: @escaping NetworkResponseHandler){
        let movieSearchResponseHandler = responseHandler
        
        guard let url = URL(string: "\(MovieDBAPI.searchQueryUrl)\(MovieDBAPI.apiKey)&query=\(searchPhrase.replacingOccurrences(of: " ", with: "%20"))") else{
            print("Unable to get URL from string.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard error == nil else {
                print("Error found while retrieving result: \(error.debugDescription)")
                movieSearchResponseHandler(nil, "No result found.")
                return
            }
            guard let content = data else {
                movieSearchResponseHandler(nil, "No result found.")
                return
            }
            
            var resultMovieInfoList: [MovieInfo] = []
            
            do{
                if let json = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any], let results = json["results"] as? [Any]{
                    var movieInfoList = [[String:Any]]()
                    for movie in results{
                        if let movieDict = movie as? [String:Any]{
                            movieInfoList += [movieDict]
                        }
                    }
                    resultMovieInfoList = MovieInfo.parseMovieInfoFrom(response: movieInfoList)
                }
            } catch let error {
                print("Error during JSONSerialization of response : \(error.localizedDescription) ")
            }
            
            movieSearchResponseHandler(resultMovieInfoList, resultMovieInfoList.count > 0 ? "" : "No result found.")
        }
        
        task.resume()
    }
}
