//
//  MainViewController.swift
//  SleepTonight
//
//  Created by Binjia Chen on 7/23/18.
//

import UIKit
import UserNotifications

class MainViewController: UIViewController {
    
    var bedtimes = [Bedtime]()
    
    @IBOutlet weak var bedtimeLabel: UILabel!
    @IBOutlet weak var bedtimeReminderLabel: UILabel!
    @IBOutlet weak var sleepButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print("Error in notification permission/authorization: \(error.localizedDescription)")
            }
        }
        
//        let bedtime = CoreDataHelper.createBedtime()
//        bedtime.time = Date()
//        bedtime.isSleeping = false
//        bedtime.prepTime = 60.0
//        CoreDataHelper.saveBedtime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bedtimes = CoreDataHelper.retrieveBedtimes()
        
        let bedtime = bedtimes[0]
        
        configureMainViewWith(bedtime: bedtime)
        
        if !bedtime.isSleeping {
            setupReminderNotification(bedtime: bedtime)
            setupBedtimeNotification(bedtime: bedtime)
            setupPersistentNotifications(bedtime: bedtime)
        }
    }
    
    func configureMainViewWith(bedtime: Bedtime) {
        if let date = bedtime.time {
            let time = date.convertToString()
            
            bedtimeLabel.text = time
        } else {
            print("Bedtime not set")
        }
        
        let prepTime = String(Int(bedtime.prepTime / 60))
        bedtimeReminderLabel.text = "\(prepTime) min"
    }
    
    func setupBedtimeNotification(bedtime: Bedtime) {
        guard let date = bedtime.time else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "IT'S YO BEDTIME"
        content.body = "Go sleep buddy."
        content.sound = UNNotificationSound.default()
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["Bedtime"])
        
        let request = UNNotificationRequest(identifier: "Bedtime", content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error in bedtime notification: \(error.localizedDescription)")
            }
        }
    }
    
    func setupReminderNotification(bedtime: Bedtime) {
        guard let time = bedtime.time else { return }
        
        let date = time - bedtime.prepTime
        
        let content = UNMutableNotificationContent()
        content.title = "Get ready to sleep!"
        content.body = "Now!!!"
        content.sound = UNNotificationSound.default()
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["BedtimeReminder"])
        
        let request = UNNotificationRequest(identifier: "BedtimeReminder", content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error in reminder notification: \(error.localizedDescription)")
            }
        }
    }
    
    func setupPersistentNotifications(bedtime: Bedtime) {
        guard let time = bedtime.time else { return }
        
        if Date() > time { // fix statement
            let content = UNMutableNotificationContent()
            content.title = "Go sleep!!"
            content.body = "It's past your bedtime!"
            content.sound = UNNotificationSound.default()
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["PersistentReminder"])
            
            let request = UNNotificationRequest(identifier: "PersistentReminder", content: content, trigger: trigger)
            
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
                if let error = error {
                    print("Error in persistent notification: \(error.localizedDescription)")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "displaySettings":
            let bedtime = bedtimes[0]
            
            let destination = segue.destination as! SettingsTableViewController
            
            destination.bedtime = bedtime
        default:
            print("Unexpected segue identifier")
        }
    }
    
    @IBAction func sleepButtonTapped(_ sender: Any) {
        let bedtime = bedtimes[0]
        
        bedtime.isSleeping = !bedtime.isSleeping
        
        if bedtime.isSleeping {
            sleepButton.setTitle("RESET", for: .normal)
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            sleepButton.setTitle("SLEEP", for: .normal)
            
            setupReminderNotification(bedtime: bedtime)
            setupBedtimeNotification(bedtime: bedtime)
            setupPersistentNotifications(bedtime: bedtime)
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
    }
}
