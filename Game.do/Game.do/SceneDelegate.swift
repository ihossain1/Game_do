//
//  SceneDelegate.swift
//  Game.do
//
//  Created by user186880 on 5/1/21.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private(set) static var shared: SceneDelegate?
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Game_do")
        container.loadPersistentStores {_, error in
            if let error = error {
                fatalError("Could not load data store: \(error)")
            }
        }
        return container
    }()
    
    lazy var managedObjectContext = persistentContainer.viewContext
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let tabController = window!.rootViewController as! UITabBarController
        if let tabViewControllers = tabController.viewControllers{
            let navController = tabViewControllers[1] as! UINavigationController
            let controller = navController.viewControllers.first as! GameSearchViewController
            controller.managedObjectContext = managedObjectContext
            
            let navController1 = tabViewControllers[0] as! UINavigationController
            let controller1 = navController1.viewControllers.first as! HomeViewController
            controller1.managedObjectContext = managedObjectContext
            
            let navController2 = tabViewControllers[2] as! UINavigationController
            let controller2 = navController2.viewControllers.first as! AllGamesViewController
            controller2.managedObjectContext = managedObjectContext
        }
        requestNotificationPermission()
        let notifScheduler = NotifScheduler.shared
        notifScheduler.coordinator = persistentContainer
        
        NotifScheduler.shared.startObserving()
        guard let _ = (scene as? UIWindowScene) else { return }
        Self.shared = self
        
        
    }
    
    // request notif
    func requestNotificationPermission(){
        let userNotificationCenter = UNUserNotificationCenter.current()
        
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        userNotificationCenter.requestAuthorization(options: authOptions){(success, error) in
            if let error = error {
                print("Error: ", error)}
        }}

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        saveContext()
    }


}

