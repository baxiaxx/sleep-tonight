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
        
//        let bedtime = CoreDataHelper.createBedtime()
//        bedtime.time = Date()
//        bedtime.isSleeping = false
//        bedtime.prepTime = 60.0
//        CoreDataHelper.saveBedtime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bedtimes = CoreDataHelper.retrieveBedtimes()
        
        configureMainViewWith(bedtime: bedtimes[0])
        bedtimeNotificationSetup(bedtime: bedtimes[0])
    }
    
    func configureMainViewWith(bedtime: Bedtime) {
        if let date = bedtime.time {
            let time = date.convertToString()
            
            bedtimeLabel.text = time
        } else {
            print("Bedtime not set")
        }
        
        let prepTime = String(bedtime.prepTime)
        bedtimeReminderLabel.text = "\(prepTime) min"
    }
    
    func bedtimeNotificationSetup(bedtime: Bedtime) {
        guard let date = bedtime.time else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "IT'S YO BEDTIME"
        content.body = "Go sleep buddy."
        content.sound = UNNotificationSound.default()
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "Bedtime", content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                print("Something went wrong with notifications")
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
        } else {
            sleepButton.setTitle("SLEEP", for: .normal)
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
    }
}
