//
//  GameSearchViewController.swift
//  Game.do
//
//  Created by user186880 on 5/15/21.
//

import Foundation
import UIKit
import CoreData


class GameSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var managedObjectContext: NSManagedObjectContext!
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = GameSearchBar.text, GameSearchBar.text?.isEmpty == false else {
            self.loadingImageView?.stopAnimating()
            self.loadingImageView?.removeFromSuperview()
            searchBar.resignFirstResponder()
            return
        }
        GameHandler.shared.searchByGameName(searchText) { (games) in
            self.retreivedGames = games
        }
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.view.addSubview(loadingImageView!)
        loadingImageView?.startAnimating()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        self.perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.retreivedGames = []
        self.searchResults.reloadData()
        searchBar.resignFirstResponder()
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        if query.isEmpty {
            self.loadingImageView?.stopAnimating()
            self.loadingImageView?.removeFromSuperview()
            print("Nothing found")
            retreivedGames = []
            return
        } else {
            print("Performing network request with query: \(query)")
            GameHandler.shared.searchByGameName(query) { (games) in
                self.retreivedGames = games
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let games = retreivedGames else {return 0}
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell"), let games = retreivedGames else { return UITableViewCell() }
        let gameForCell = games[indexPath.row]
        cell.textLabel?.text = gameForCell.name
        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let games = retreivedGames else { return }
        let selectedGame = games[indexPath.row]
        selectedVideoGame = selectedGame
        GameSearchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSearchbar()
        setupTableView()
        resignFirstResponderTapRecongnizerSetup()
        loadingImageView = UIImageView(frame: CGRect(x: (view.bounds.width / 2.0) - ((view.bounds.width / 5.0)) / 2.0, y: (view.bounds.height / 3.0) - ((view.bounds.width / 5.0)) / 2.0, width: view.bounds.width / 5.0, height: view.bounds.width / 5.0))
        loadingImageView!.animationImages = loadingImages
        loadingImageView!.animationDuration = 1.0
    }
    
    // MARK: - Variables
    let loadingImages = (1...8).map { (i) -> UIImage in
        return UIImage(named: "\(i)")!
    }
    var loadingImageView: UIImageView?
    
    var selectedVideoGame: Game? {
        didSet {
            getGameArtwork()
        }
    }
    var selectedGameArtwork: [Artwork]? {
        didSet {
            DispatchQueue.main.async {
                 self.performSegue(withIdentifier: "toShowGame", sender: self)
            }
        }
    }
    var retreivedGames: [Game]? {
        didSet {
            DispatchQueue.main.async {
                self.searchResults.reloadData()
                self.loadingImageView?.stopAnimating()
                self.loadingImageView?.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var searchResults: UITableView!
    @IBOutlet weak var GameSearchBar: UISearchBar!
    
    // MARK: - Internal Methods
    
    private func setupSearchbar() {
        GameSearchBar.delegate = self
    }
    
    private func setupTableView() {
        searchResults.delegate = self
        searchResults.dataSource = self
    }
    
    private func getGameArtwork() {
       guard let game = selectedVideoGame else { return }
       GameHandler.shared.getCoverArtworkByGameId(game.id) { (artworks) in
           self.selectedGameArtwork = artworks
       }
    }
    
    private func resignFirstResponderTapRecongnizerSetup() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowGame" {
            guard let detailVC = segue.destination as? GameDetailViewController, let game = selectedVideoGame, let artworks = selectedGameArtwork else { return }
            detailVC.artworks = artworks
            detailVC.gameId = game.id
            detailVC.gamePlatformIds = game.platforms
            detailVC.genreIds = game.genres
            detailVC.gameModeIds = game.game_modes
            detailVC.game = game
            detailVC.summary = game.summary
            detailVC.managedObjectContext = managedObjectContext
        }
    }
}


