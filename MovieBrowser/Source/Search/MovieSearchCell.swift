//
//  MovieSearchCell.swift
//  MovieBrowser
//
//  Created by Sandhya Mali on 5/22/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class MovieViewCell: UITableViewCell {
    static let identifier = "MovieViewCell"
    let releaseDateFormat = "MMMM dd, yyyy"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func populateCell(movie:MovieInfo){
        titleLabel.text =  movie.title
        if let formattedDate = movie.releaseDate.getDate(){
            releaseDateLabel.text = formattedDate.getFormattedDate(format: releaseDateFormat)
        }
        voteAverageLabel.text = "\(movie.voteAverage)"
    }
    
}
