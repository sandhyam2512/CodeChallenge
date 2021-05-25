//
//  MovieDetailViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/26/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var moviePosterImage: UIImageView!
    @IBOutlet weak var movieOverviewText: UITextView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    var movieInfo : MovieInfo?
    
    override func viewDidLoad() {
        if let movieDetails = movieInfo{
            movieTitleLabel.text = movieDetails.title
            movieOverviewText.text = movieDetails.overview
            movieReleaseDateLabel.text = "Release Date: \(movieDetails.releaseDate)"
            getPosterImageFrom(path: movieDetails.posterPath)
        }
    }
    
    func getPosterImageFrom(path: String) {
        guard let url = URL(string: "\(MovieDBAPI.imageDownloadUrl.rawValue)\(path)") as URL? else {
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
            }
            if  let imageData = data, let downloadedImage = UIImage(data: imageData){
                DispatchQueue.main.async {
                    self.moviePosterImage.image = downloadedImage
                    self.moviePosterImage.image = downloadedImage.aspectFitImage(inRect: self.moviePosterImage.frame)
                    self.moviePosterImage.contentMode = .top
                }
            }
        }).resume()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async {
            self.moviePosterImage.image = UIDevice.current.orientation.isLandscape ? self.moviePosterImage.image?.aspectFitImage(inRect: self.moviePosterImage.frame) : self.moviePosterImage.image?.aspectFitImage(inRect: self.moviePosterImage.frame)
            self.moviePosterImage.contentMode = UIDevice.current.orientation.isLandscape ? .center : .top
        }
    }
}
