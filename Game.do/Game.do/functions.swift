//
//  functions.swift
//  Game.do
//
//  Created by user186880 on 5/23/21.
//

import Foundation
import UIKit

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}

let dataSaveFailedNotification = Notification.Name(rawValue: "DataSaveFailedNotification")

func fatalCoreDataError(_ error: Error) {
  print("*** Fatal error: \(error)")
  NotificationCenter.default.post(name: dataSaveFailedNotification, object: nil)
}

