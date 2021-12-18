//
//  TaskListViewController.swift
//  Game.do
//
//  Created by user186880 on 5/27/21.
//

import Foundation
import UIKit
import CoreData
import AVFoundation

class TaskListViewController: UITableViewController, TaskDetailViewControllerDelegate{
    @IBOutlet weak var viewAnimation: UIView!
    var imageView2  = UIImageView()
    var player: AVAudioPlayer?
    func taskDetailViewControllerDidCancel(_ controller: TaskDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        player?.stop()
    }
    func taskDetailViewController(_ controller: TaskDetailViewController, didFinishAdding item: Tasks) {
        let newRowIndex = (savedGame?.tasks?.allObjects.count)! - 1
        savedGame?.addToTasks(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        // saveChecklistItems()
    }
    
    var savedGame: SavedGame?
    var managedObjectContext: NSManagedObjectContext!
    
    func configureCheckmark(for cell: UITableViewCell,
                            with item: Tasks){
        
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked{
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell,
                       with item: Tasks){
        let label = cell.viewWithTag(1000) as! UILabel
        // label.text = item.text
        label.text = "\(String(describing: item.detail))"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "AddItem"{
            let controller = segue.destination as! TaskDetailViewController
            controller.delegate = self
            controller.savedGame = savedGame!
        } else if segue.identifier == "EditItem"{
            let controller = segue.destination as! TaskDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                let taskList = savedGame!.tasks!.allObjects as! [Tasks]
                controller.itemToEdit = taskList[indexPath.row]
                controller.savedGame = savedGame!
            }
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "task", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        if(savedGame?.tasks!.count == 0){
            let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "tasks", withExtension: "gif")!)
              let advTimeGif = UIImage.gifImageWithData(imageData!)
            imageView2 = UIImageView(image: advTimeGif)
              imageView2.frame = CGRect(x: 20.0, y: 220.0, width:
              self.view.frame.size.width - 40, height: 150.0)
              view.addSubview(imageView2)
            playSound()
        }
        else{
            player?.stop()
            for v in view.subviews{
               v.removeFromSuperview()
            }
        }
        return (savedGame?.tasks!.count)!
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskItem", for: indexPath)
        
        let item = savedGame!.tasks!.allObjects[indexPath.row]
        
        configureText(for: cell, with: item as! Tasks)
        configureCheckmark(for: cell, with: item as! Tasks)
        return cell
    }
    
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ){
        if let cell = tableView.cellForRow(at: indexPath){
            let item = savedGame!.tasks!.allObjects[indexPath.row]
            (item as! Tasks).checked.toggle()
            configureCheckmark(for: cell, with: item as! Tasks)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        // saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath){
        let item = savedGame!.tasks!.allObjects[indexPath.row] as! Tasks
        savedGame?.removeFromTasks(item)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        do {
            try managedObjectContext.save()
        } catch {print(error.localizedDescription)}
        
        tableView.reloadData()
    }
    
    func taskDetailViewController(
        _ controller: TaskDetailViewController,
        didFinishEditing item: Tasks
    ) {
        let taskList = savedGame!.tasks!.allObjects as! [Tasks]
        if let index = taskList.firstIndex(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, with: item)
            }
        navigationController?.popViewController(animated: true)
        // saveChecklistItems()
    }
}
}

extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL? = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL!) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
}
