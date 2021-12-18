//
//  NotifScheduler.swift
//  Game.do
//
//  Created by user207650 on 12/17/21.
//

import Foundation
import CoreData
import UserNotifications


extension NSNotification.Name {
    static let TasksUpdated = NSNotification.Name("Tasks.Updated")
}

class NotifScheduler: NSObject{
    
    static let shared = NotifScheduler()
    
    var coordinator: NSPersistentContainer!
    var timer: Timer?
    func startObserving(){
        
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true, block: {
           [weak self] timer in
            
            DispatchQueue.global(qos: .background).async {
                self?.fetchActiveTasks()
            }
            
        })
    }
    
    func fetchActiveTasks(){
        // fetch core data list of tasks with predicate of active tasks
        let context = self.coordinator.newBackgroundContext()
        let predicate = NSPredicate(format: "shouldRemind = TRUE AND date <= %@", argumentArray: [Date()])
        let fetchRequest = NSFetchRequest<Tasks>()
        
        let entity = Tasks.entity()
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            
            let tasks = try context.fetch(fetchRequest)
            for task in tasks {
                createNotification(task: task)
                markTaskUpdated(task: task)
                sendUpdateNotification(task: task)
            }
        } catch {
            fatalCoreDataError(error)
        }
        //any tasks that is past due send notif
        
        // update core data as needed
        
        // send NSNotification for task completion/past due
    }
    
    func markTaskUpdated(task: Tasks) {
        
        let objectIdentifier = task.objectID
        
        DispatchQueue.main.async {
            
            let context = SceneDelegate.shared!.managedObjectContext
            
            let localTask = context.object(with: objectIdentifier) as! Tasks
            
            localTask.shouldRemind = false
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func createNotification(task: Tasks){
        let userNotificationCenter = UNUserNotificationCenter.current()
        // Create new notifcation content instance
        let notificationContent = UNMutableNotificationContent()

        // Add the content to the notification content
        notificationContent.title = "Test"
        notificationContent.body = "Test body"

        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: nil)
        print("default")
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    func stopObserving(){
        timer?.invalidate()
    }
    
    func sendUpdateNotification(task: Tasks) {

        NotificationCenter.default.post(name: NSNotification.Name.TasksUpdated, object: nil)
    }
    

}


