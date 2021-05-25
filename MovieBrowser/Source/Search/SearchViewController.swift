//
//  SearchViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/19/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTable: UITableView!
    @IBOutlet weak var errorDetailView: UIView!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var errorDetailLabel: UILabel!
    
    var searchResult: [MovieInfo] = []
    let segueIdentifier = "MovieDetail"
    
    override func viewDidLoad() {
        searchResultTable.dataSource = self
        searchResultTable.delegate = self
        errorDetailView.isHidden = false
        searchResultTable.isHidden = true
        searchBar.delegate = self
    }
    
    @IBAction func searchMovies(_ sender: Any) {
        searchforMovies()
    }
    
    func searchforMovies(){
        goButton.isEnabled = false
        searchBar.resignFirstResponder()
        let networkRequest = Network()
        if let searchTerm = searchBar.text {
            networkRequest.downloadMovieInfo(searchPhrase: searchTerm) { (movieList, errorMsg)  in
                self.searchResult = movieList ?? []
                DispatchQueue.main.async {
                    self.goButton.isEnabled = self.searchResult.count > 0 ? true : false
                    self.errorDetailView.isHidden = self.searchResult.count > 0 ? true : false
                    self.searchResultTable.isHidden = self.searchResult.count > 0 ? false : true
                    if self.searchResult.count > 0{
                        self.searchResultTable.reloadData()
                    } else{
                        self.errorDetailLabel.text = errorMsg
                        self.viewDidLayoutSubviews()
                    }
                }
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieViewCell.identifier) as! MovieViewCell
        cell.accessoryType = .disclosureIndicator
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.systemBlue
        cell.selectedBackgroundView = backgroundView
        let movie = searchResult[indexPath.row]
        cell.populateCell(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            if let selectedIndex = self.searchResultTable.indexPathForSelectedRow?.item, let dest = segue.destination as? MovieDetailViewController{
                dest.movieInfo = searchResult[selectedIndex]
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchforMovies()
    }
}
