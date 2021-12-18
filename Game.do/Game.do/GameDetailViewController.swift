//
//  GameDetailViewController.swift
//  Game.do
//
//  Created by user186880 on 5/16/21.
//

import Foundation
import UIKit
import CoreData

class GameDetailViewController: UIViewController{
    
    var managedObjectContext: NSManagedObjectContext!
    
    var coverImageCallCompleted = false
    var platformTagsCallCompleted = false
    var genreTagsCallCompleted = false
    var gameModeTagsCallCompleted = false
    var imageHasChanged = false
    
    var summary: String?
    var gameTitle: String?
    
    var gameModeIds: [Int]?
    var gameModes: [GameMode]?
    
    var genreIds: [Int]?
    var genres: [Genre]?
     // PLATFORMS:
    var gamePlatforms: [Platform]?
    var gamePlatformIds: [Int]?
     // GAME COVER:
    var gameId: Int?
    var artworks: [Artwork]?
    var gameCover: UIImage? {
     didSet {
         DispatchQueue.main.async {
             self.updateImageView()
             }
         }
     }
    // GAME:
    var game: Game? {
       didSet {
        if artworks == nil {
            coverImageCallCompleted = true
        }
        if gamePlatformIds == nil {
            platformTagsCallCompleted = true
        }
        if genreIds == nil {
            genreTagsCallCompleted = true
        }
        if gameModeIds == nil {
            gameModeTagsCallCompleted = true
        }
        if let artworkArray = artworks {
            GameHandler.shared.getCoverImageByArtworks(artworkArray) { (image) in
                self.coverImageCallCompleted = true
                guard let coverImage = image else { return }
                self.gameCover = coverImage
                self.imageHasChanged = true
            }
        }
        if let platformIds = gamePlatformIds {
            GameHandler.shared.getPlatformsByPlatformIds(platformIds) { (gamePlatforms) in
                self.platformTagsCallCompleted = true
                self.gamePlatforms = gamePlatforms
                print(gamePlatforms[0].name)
            }
        }
        if let genres = genreIds {
            GameHandler.shared.getGenresByGenreIds(genres) { (genres) in
                self.genreTagsCallCompleted = true
                self.genres = genres
                print(genres[0].name)
            }
        }
        if let modeIds = gameModeIds {
            GameHandler.shared.getGameModesByModeIds(modeIds) { (gameModes) in
                self.gameModeTagsCallCompleted = true
                self.gameModes = gameModes
                print(gameModes[0].name)
                }
            }
        }
    }
    
    var savedGame: SavedGame?
    
    @IBOutlet weak var coverArtImageView: UIImageView!

    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var platformsLabel: UILabel!
    @IBOutlet weak var gameName: UILabel!
    
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    @IBOutlet weak var summaryText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSavedGameDetails()
        normalSetup()
        
        }
    

    
    //private func generateGenreLabel(){
      //  var toBeCombined: [String] = []
        // var finalString: String
        // for item in genres!{
            // toBeCombined.append(item.name)
        // }
        // finalString = toBeCombined.joined(separator: ", ")
        // self.genresLabel.text = finalString as String?
    // }
    

    @IBAction func saveButtonPress(_ sender: Any){
        save()
    }
        
  /*  private func generateGenreText(){
        if let gameGenres = genres{
            var genreText = ""
            for genre in gameGenres{
                genreText.append(genre.name)
                genreText.append(", ")
            }
            genresLabel.text = genreText
        }
    }*/
    
   /* private func generatePlatformText(){
        if let consoles = gamePlatforms{
            var platformText = ""
            for console in consoles {
                platformText.append(console.name)
                platformText.append(", ")
            }
            platformsLabel.text = platformText
        }
    }*/
    
    private func updateImageView() {
       if let gameImage = gameCover {
          self.coverArtImageView.image = gameImage
       }
    }
    
    private func save() {
//        let managedObjectContext =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let savedGame = SavedGame(context: managedObjectContext)
        savedGame.title = gameName.text
        savedGame.id = Int64(gameId!)
        savedGame.summary = summaryText.text
        savedGame.image = coverArtImageView.image?.pngData()
        
        do {
            try managedObjectContext.save()
            afterDelay(0.6){
                self.navigationController?.popViewController(animated: true)
            }
        }
        catch{
            //fatalError("Error: \(error)")
        }
    }
    
    private func setupSavedGameDetails(){
        guard let saveGame = savedGame else {return}
        gameName.text = saveGame.title
        summaryText.text = saveGame.summary
        coverArtImageView.image = UIImage(data: saveGame.image ?? Data())
        genresLabel.text = " "
        platformsLabel.text = " "
    }
    
    private func normalSetup(){

        
        if let selectedGame = game{
            gameName.text = selectedGame.name
            summaryText.text = selectedGame.summary as String?
            /*if(genreIds?.count ?? 0 > 0){
              genresLabel.text = String(genreIds![0])
            }*/
            if let gameGenres = genres{
                var genreText = ""
                for genre in gameGenres{
                    genreText.append(genre.name)
                    genreText.append(", ")
                }
                genresLabel.text = genreText
            }
            
            if let consoles = gamePlatforms{
                var platformText = ""
                for console in consoles {
                    platformText.append(console.name)
                    platformText.append(", ")
                }
                platformsLabel.text = platformText
            }
            /*for item in gamePlatforms!{
                genresLabel.text!+=(item.name+", ")
            }*/
            //platformsLabel.text = String(gamePlatformIds![0])
//            self.platformsLabel.text = String(gamePlatformIds![0])
            
            /*platformsLabel.text = gamePlatforms?[0].name
            print(platformsLabel.text)*/
            
        }
        
    }
       
   
}
