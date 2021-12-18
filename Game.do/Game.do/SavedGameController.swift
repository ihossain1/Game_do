//
//  SavedGameController.swift
//  Game.do
//
//  Created by user186880 on 5/20/21.
//

import Foundation
import UIKit
import CoreData

class SavedGameController {
    
    var managedObjectContext: NSManagedObjectContext!
    
    // MARK: - Shared instance
    static let shared = SavedGameController()
    
//    var savedGames: [SavedGame] {
//        let request: NSFetchRequest<SavedGame> = SavedGame.fetchRequest()
//        let moc = CoreDataStack.context
//        do {
//            let result = try moc.fetch(request)
//            return result
//        } catch {
//            return []
//        }
//    }
//
//
//    // MARK: - Save and Delete
//
//    func createSavedGame(title: String,
//                         image: UIImage,
//                         id: Int){
//        let imageData: Data?
//        imageData = image.jpegData(compressionQuality: 1.0)
//        let savedGame = SavedGame(title: title, image: imageData, id: id)
//
//        saveToPersistentStorage()
//    }
//
//    func deleteSavedGame(savedGame: SavedGame){
//        let moc = savedGame.managedObjectContext
//        moc?.delete(savedGame)
//        saveToPersistentStorage()
//    }
//
//
//    func saveToPersistentStorage() {
//        do {
//            try CoreDataStack.context.save()
//        } catch {
//            print(error,error.localizedDescription)
//        }
//    }
    
}
