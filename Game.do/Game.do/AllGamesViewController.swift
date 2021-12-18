//
//  AllGamesViewController.swift
//  Game.do
//
//  Created by user186880 on 5/27/21.
//

import Foundation
import UIKit
import CoreData


class AllGamesViewController: UITableViewController{
    var games = [SavedGame]()
    var managedObjectContext: NSManagedObjectContext!
    
    func didTap(index: IndexPath){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.updateTasks()
        self.observeChanges()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func observeChanges() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.TasksUpdated, object: nil, queue: nil) { [weak self] note in
            self?.updateTasks()
        }
    }
    
    func updateTasks() {
        let fetchRequest = NSFetchRequest<SavedGame>()
        
        let entity = SavedGame.entity()
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            
            games = try managedObjectContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameTaskCell", for: indexPath) as! GameTaskCell
        
        let game = games[indexPath.row]
        cell.configure(for: game)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = games[indexPath.row]
        performSegue(withIdentifier: "ShowTaskList", sender: game)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTaskList"{
            let controller = segue.destination as! TaskListViewController
            controller.savedGame = sender as? SavedGame
            controller.managedObjectContext = managedObjectContext
        }
    }
}
