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
    var isDefaultStatusBar = true
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isDefaultStatusBar ? .lightContent : .default
    }
    
    @IBOutlet weak var bedtimeLabel: UILabel!
    
    @IBOutlet weak var reminderView: UIView!
    @IBOutlet weak var reminderAmountLabel: UILabel!
    
    @IBOutlet weak var sleepButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print("Error in notification permission/authorization: \(error.localizedDescription)")
            }
        }
        
        if !isNotFirstLaunch() {
            let bedtime = CoreDataHelper.createBedtime()
            bedtime.time = Date()
            bedtime.isSleeping = false
            bedtime.prepTime = 0.0
            bedtime.hasNotifs = true
            CoreDataHelper.saveBedtime()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bedtimes = CoreDataHelper.retrieveBedtimes()
        
        let bedtime = bedtimes[0]
        
        setupView(bedtime: bedtime)
        
        if bedtime.isSleeping {
            sleepButton.setTitle(Constants.ButtonText.afterSleep, for: .normal)
            setTheme(isLight: true)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            sleepButton.setTitle(Constants.ButtonText.beforeSleep, for: .normal)
            setTheme(isLight: false)
            setupNotifications(bedtime: bedtime)
        }
    }
    
    func isNotFirstLaunch() -> Bool {
        let defaults = UserDefaults.standard
        
        if let _ = defaults.string(forKey: Constants.Defaults.isNotFirstLaunch) {
            return true
        } else {
            defaults.set(true, forKey: Constants.Defaults.isNotFirstLaunch)
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "displaySettings":
            let bedtime = bedtimes[0]
            
            let destination = segue.destination as? SettingsTableViewController
            
            destination?.bedtime = bedtime
        default:
            print("Unexpected segue identifier")
        }
    }
    
    @IBAction func sleepButtonTapped(_ sender: Any) {
        let bedtime = bedtimes[0]
        
        bedtime.isSleeping = !bedtime.isSleeping
        
        if bedtime.isSleeping {
            sleepButton.setTitle(Constants.ButtonText.afterSleep, for: .normal)
            setTheme(isLight: true)
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            sleepButton.setTitle(Constants.ButtonText.beforeSleep, for: .normal)
            setTheme(isLight: false)
            
            setupNotifications(bedtime: bedtime)
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
    }
    
    // MARK: - Functions
    
    func setupView(bedtime: Bedtime) {
        if let date = bedtime.time {
            bedtimeLabel.text = date.convertToString()
        } else {
            print("Bedtime not set")
        }
        
        let prepTime = String(Int(bedtime.prepTime / 60))
        reminderAmountLabel.text = "Bedtime Reminder: \(prepTime) min"
        
        reminderView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        sleepButton.layer.cornerRadius = 8
        sleepButton.layer.masksToBounds = true
    }
    
    func setTheme(isLight: Bool) {
        let theme = isLight ? ColorTheme.light : ColorTheme.dark
        
        view.backgroundColor = theme.backgroundColor
        
        bedtimeLabel.textColor = theme.primaryTextColor
        
        reminderView.backgroundColor = theme.secondaryColor
        
        reminderAmountLabel.textColor = theme.secondaryTextColor
        
        sleepButton.backgroundColor = theme.accentColor
    }
    
    func setupNotifications(bedtime: Bedtime) {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        setupReminderNotification(bedtime: bedtime)
        setupBedtimeNotification(bedtime: bedtime)
        if bedtime.hasNotifs {
            setupPersistentNotifications(bedtime: bedtime)
        }
    }
    
    func setupBedtimeNotification(bedtime: Bedtime) {
        guard let date = bedtime.time else { return }
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        let title = "Bedtime"
        let body = "Time to sleep!"
        let identifier = "Bedtime"
        
        let notification = Notification(title: title, body: body, identifier: identifier, dateMatching: dateComponents)
        notification.createNotification()
    }
    
    func setupReminderNotification(bedtime: Bedtime) {
        guard let time = bedtime.time else { return }
        
        let date = time - bedtime.prepTime
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        let title = "Bedtime Reminder"
        let body = "\(String(Int(bedtime.prepTime / 60))) min until bedtime."
        let identifier = "BedtimeReminder"
        
        let notification = Notification(title: title, body: body, identifier: identifier, dateMatching: dateComponents)
        notification.createNotification()
    }
    
    func setupPersistentNotifications(bedtime: Bedtime) {
        guard let time = bedtime.time else { return }
        
        let title = "Still awake?"
        var body = "Stop, drop, and go to bed."
        let identifier = "PersistentReminder"
        
        for i in 1...50 {
            if i == 50 {
                body = "LAST REMINDER. Chop chop."
            }
            let timeInterval = TimeInterval(i * 120)
            let newDate = time + timeInterval
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: newDate)
            let notification = Notification(title: title, body: body, identifier: identifier + String(i), dateMatching: dateComponents)
            notification.createNotification()
        }
    }
}
