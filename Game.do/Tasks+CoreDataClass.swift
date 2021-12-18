//
//  Tasks+CoreDataClass.swift
//  Game.do
//
//  Created by user186880 on 5/23/21.
//
//

import Foundation
import CoreData
import UserNotifications

@objc(Tasks)
public class Tasks: NSManagedObject {

    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(detail)"])
    }
    
    func scheduleNotification(){
        removeNotification()
        if shouldRemind && date > Date(){
            // 1
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = detail
            content.sound = UNNotificationSound.default
            
            // 2
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            
            // 3
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            // 4
            let request = UNNotificationRequest(identifier: "\(detail)", content: content, trigger: trigger)
            
            // 5
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("Scheduled: \(request) for detail: \(detail)")
        }
    }
}
