//
//  TaskDetailViewController.swift
//  Game.do
//
//  Created by user186880 on 5/28/21.
//

import Foundation
import UIKit
import CoreData
import UserNotifications

protocol TaskDetailViewControllerDelegate: class {
    func taskDetailViewControllerDidCancel(
        _ controller: TaskDetailViewController)
    
    func taskDetailViewController(
        _ controller: TaskDetailViewController,
        didFinishAdding item: Tasks
    )
    func taskDetailViewController(
        _ controller: TaskDetailViewController,
        didFinishEditing item: Tasks
    )
}

class TaskDetailViewController: UITableViewController, UITextFieldDelegate{
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var remindMe: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
//    var managedObjectContext: NSManagedObjectContext!
    
    var savedGame: SavedGame?
    weak var delegate: TaskDetailViewControllerDelegate?
    var itemToEdit: Tasks?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        if let item = itemToEdit{
            title = "Edit Task"
            textField.text = item.detail
            doneBarButton.isEnabled = true
            remindMe.isOn = item.shouldRemind
            datePicker.date = item.date
        }
    }
    
    //MARK: - Table View Delegates
    override func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    //MARK: - Actions
    @IBAction func cancel(){
        delegate?.taskDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(){
        if let item = itemToEdit{
            item.detail = textField.text!
            item.shouldRemind = remindMe.isOn
            item.date = datePicker.date
            item.scheduleNotification()
            do {try SceneDelegate.shared!.managedObjectContext.save()}
            catch{print(error.localizedDescription)}
            delegate?.taskDetailViewController(self, didFinishEditing: item)
        } else {
            
//            guard let appDelegate =
//                UIApplication.shared.delegate as? AppDelegate else {
//                return
//              }
//              
//              // 1
//              let managedContext =
//                appDelegate.persistentContainer.viewContext
//              
//              // 2
//              let entity =
//                NSEntityDescription.entity(forEntityName: "Person",
//                                           in: managedContext)!
//              
//              let person = NSManagedObject(entity: entity,
//                                           insertInto: managedContext)
//              
//              // 3
//              person.setValue(textField.text!, forKeyPath: "name")
//              
            
            let item = Tasks(context: SceneDelegate.shared!.managedObjectContext)
//            item.setValue(textField.text!, forKey: "detail")
            item.detail = textField.text!
            item.checked = false
            item.shouldRemind = remindMe.isOn
            item.date = datePicker.date
            item.scheduleNotification()
            savedGame!.addToTasks(item)
            do {try SceneDelegate.shared!.managedObjectContext.save()}
            catch{print(error.localizedDescription)}
            delegate?.taskDetailViewController(self, didFinishAdding: item)
        }
    }
    
    //MARK: - Text Field Delegates
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool{
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty{
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch){
        textField.resignFirstResponder()
        
        if switchControl.isOn{
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]){_, _ in
                //do nothing
            }
        }

    }
}
