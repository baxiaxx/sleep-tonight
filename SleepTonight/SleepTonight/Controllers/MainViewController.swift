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
            let time = date.convertToString()
            
            bedtimeLabel.text = time
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
        
        timer = Timer(fireAt: time, interval: 60, target: self, selector: #selector(setupPersistentNotifications), userInfo: bedtime, repeats: false)
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    
    func createNotificationContent(title: String, body: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        
        return content
    }
    
    func createNotificationRequest(identifier: String, content: UNMutableNotificationContent, trigger: UNNotificationTrigger) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }
    
    func setupBedtimeNotification(bedtime: Bedtime) {
        guard let date = bedtime.time else { return }
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        let content = createNotificationContent(title: "IT'S YO BEDTIME", body: "Go sleep buddy.")
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        createNotificationRequest(identifier: "Bedtime", content: content, trigger: trigger)
    }
    
    func setupReminderNotification(bedtime: Bedtime) {
        guard let time = bedtime.time else { return }
        
        let date = time - bedtime.prepTime
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        let content = createNotificationContent(title: "Get ready to sleep!", body: "Now!!!")
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        createNotificationRequest(identifier: "BedtimeReminder", content: content, trigger: trigger)
    }
    
    @objc func setupPersistentNotifications() {
        let content = createNotificationContent(title: "Go sleep!!", body: "It's past your bedtime!")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        createNotificationRequest(identifier: "PersistentReminder", content: content, trigger: trigger)
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
