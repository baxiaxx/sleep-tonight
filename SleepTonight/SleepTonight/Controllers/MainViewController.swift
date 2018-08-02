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
//    var timer = Timer()
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
            bedtime.prepTime = 60.0
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
//            timer.invalidate()
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
//        guard let time = bedtime.time else { return }
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        timer.invalidate()
        
        setupReminderNotification(bedtime: bedtime)
        setupBedtimeNotification(bedtime: bedtime)
        setupPersistentNotifications(bedtime: bedtime)
        
//        if !bedtimeIsGreaterThanCurrentTime(bedtime: time) {
//            return
//        }
//
//        timer = Timer(fireAt: time, interval: 5.0, target: self, selector: #selector(setupPersistentNotifications), userInfo: nil, repeats: false)
//        timer.tolerance = 10.0
//        RunLoop.main.add(timer, forMode: .commonModes)
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
    
    @objc func setupPersistentNotifications(bedtime: Bedtime) {
        guard let time = bedtime.time else { return }
        
        let title = "Still awake?"
        let body = "Stop, drop, and go to bed."
        let identifier = "PersistentReminder"
//        let timeInterval: TimeInterval = 60.0
        
//        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        
        for i in 1...30 {
            let timeInterval = TimeInterval(i * 120)
            let newDate = time + timeInterval
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: newDate)
            let notification = Notification(title: title, body: body, identifier: identifier + String(i), dateMatching: dateComponents)
            notification.createNotification()
        }
    
//        let notification = Notification(title: title, body: body, identifier: identifier, timeInterval: timeInterval)
//        notification.createNotification()
    }
    
    func bedtimeIsGreaterThanCurrentTime(bedtime: Date) -> Bool{
        let cal = Calendar.current
        let components = cal.dateComponents([.hour, .minute], from: bedtime)
        
        let currentDate = Date()
        let currentComponents = cal.dateComponents([.hour, .minute], from: currentDate)
        
        guard let hour = components.hour,
            let minute = components.minute,
            let currentHour = currentComponents.hour,
            let currentMinute = currentComponents.minute else { return false }
        
        if hour > currentHour {
            return true
        }
        if hour == currentHour && minute > currentMinute {
            return true
        }
        
        return false
    }
}
