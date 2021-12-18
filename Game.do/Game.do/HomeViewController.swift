//
//  ViewController.swift
//  Game.do
//
//  Created by user186880 on 5/1/21.
//
import Foundation
import UIKit
import CoreData
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class HomeViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var games = [SavedGame]()
    var managedObjectContext: NSManagedObjectContext!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest<SavedGame>()
        
        let entity = SavedGame.entity()
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            
            games = try managedObjectContext.fetch(fetchRequest)
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest = NSFetchRequest<SavedGame>()
        
        let entity = SavedGame.entity()
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            
            games = try managedObjectContext.fetch(fetchRequest)
        } catch {
            fatalCoreDataError(error)
        }
        tableView.reloadData()
    }


    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameCell
        
        let game = games[indexPath.row]
        cell.configure(for: game)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = games[indexPath.row]
        performSegue(withIdentifier: "toShowSavedGame", sender: game)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let game = games[indexPath.row]
        let moc = game.managedObjectContext
        moc?.delete(game)
        do {
            try managedObjectContext.save()
        } catch {print(error.localizedDescription)}
        
        let fetchRequest = NSFetchRequest<SavedGame>()
        
        let entity = SavedGame.entity()
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            
            games = try managedObjectContext.fetch(fetchRequest)
        } catch {
            fatalCoreDataError(error)
        }
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowSavedGame"{
            let controller = segue.destination as! GameDetailViewController
            controller.savedGame = sender as? SavedGame
          }
    }
    
    
//    func fetchTopGames(){
//
//        let parameters = "fields name, summary;\r\nwhere rating > 85;\r\nlimit 50;"
//        let postData = parameters.data(using: .utf8)
//
//        var request = URLRequest(url: URL(string: "https://api.igdb.com/v4/games/")!,timeoutInterval: Double.infinity)
//        request.addValue("wyddew28i6etbmp8ftslif5iau2rge", forHTTPHeaderField: "Client-ID")
//        request.addValue("Bearer fjp1tnir9lkdyuj1adnqu2unohmb0d", forHTTPHeaderField: "Authorization")
//        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
//
//        request.httpMethod = "POST"
//        request.httpBody = postData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//          guard let data = data else {
//            print(String(describing: error))
//            return
//          }
//          print(String(data: data, encoding: .utf8)!)
//        }
//
//        task.resume()
//
//    }
    
}

