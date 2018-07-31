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
    
    var timer = Timer()
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bedtimes = CoreDataHelper.retrieveBedtimes()
        
        let bedtime = bedtimes[0]
        
        configureMainViewWith(bedtime: bedtime)
        
        if !bedtime.isSleeping {
            setupNotifications(bedtime: bedtime)
        }
    }
    
    func configureMainViewWith(bedtime: Bedtime) {
        if let date = bedtime.time {
            bedtimeLabel.text = date.convertToString()
        } else {
            print("Bedtime not set")
        }
        
        let prepTime = String(Int(bedtime.prepTime / 60))
        bedtimeReminderLabel.text = "\(prepTime) min"
    }
    
    func setupNotifications(bedtime: Bedtime) {
        guard let time = bedtime.time else { return }
        
        setupReminderNotification(bedtime: bedtime)
        setupBedtimeNotification(bedtime: bedtime)
        
        timer.invalidate()
        
        if !bedtimeIsGreaterThanTime(time: time) {
            return
        }

        timer = Timer(fireAt: time, interval: 5.0, target: self, selector: #selector(setupPersistentNotifications), userInfo: nil, repeats: false)
        timer.tolerance = 10.0
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    
    func setupBedtimeNotification(bedtime: Bedtime) {
        guard let date = bedtime.time else { return }
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        let title = "Bedtime"
        let body = "Tap for more reminders."
        let identifier = "Bedtime"
        
        let notification = Notification(title: title, body: body, identifier: identifier, dateMatching: dateComponents)
        notification.createNotification()
    }
    
    func setupReminderNotification(bedtime: Bedtime) {
        guard let time = bedtime.time else { return }

        let date = time - bedtime.prepTime
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        let title = "Bedtime Reminder"
        let body = "\(String(Int(bedtime.prepTime / 60))) min before bedtime."
        let identifier = "BedtimeReminder"
        
        let notification = Notification(title: title, body: body, identifier: identifier, dateMatching: dateComponents)
        notification.createNotification()
    }
    
    @objc func setupPersistentNotifications() {
        let title = "Go sleep!!"
        let body = "It's past your bedtime."
        let identifier = "PersistentReminder"
        let timeInterval: TimeInterval = 60.0
        
        let notification = Notification(title: title, body: body, identifier: identifier, timeInterval: timeInterval)
        notification.createNotification()
    }
    
    func bedtimeIsGreaterThanTime(time: Date) -> Bool{
        let cal = Calendar.current
        let components = cal.dateComponents([.hour, .minute], from: time)
        
        let currentDate = Date()
        let currentComponents = cal.dateComponents([.hour, .minute], from: currentDate)
        
        if components.hour! > currentComponents.hour! {
            return true
        }
        if components.hour! == currentComponents.hour! && components.minute! > currentComponents.minute! {
            return true
        }
        
        return false
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
            timer.invalidate()
        } else {
            sleepButton.setTitle("SLEEP", for: .normal)
            
            setupNotifications(bedtime: bedtime)
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
    }
}
