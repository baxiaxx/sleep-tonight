//
//  SettingsTableViewController.swift
//  SleepTonight
//
//  Created by Binjia Chen on 7/25/18.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    weak var bedtime: Bedtime?
    
    var timePicked: Date?
    var notifChoice: Bool?
    
    @IBOutlet weak var bedtimePicker: UIDatePicker!
    @IBOutlet weak var notifSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let bedtime = bedtime,
            let time = bedtime.time else { return }
        
        bedtimePicker.date = time
        notifSwitch.isOn = bedtime.hasNotifs
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let bedtime = bedtime else { return }
        
        switch identifier {
        case "doneWithSettings":
            if let timePicked = timePicked {
                bedtime.time = timePicked
            }
            if let notifChoice = notifChoice {
                bedtime.hasNotifs = notifChoice
            }
            
            CoreDataHelper.saveBedtime()
            
        case "displayReminderOptions":
            let destination = segue.destination as! BedtimeReminderOptionsViewController
            destination.bedtime = bedtime
            
        default:
            print("Unexpected segue identifier")
        }
    }
    
    @IBAction func bedtimePickerValueChanged(_ sender: UIDatePicker) {
        timePicked = sender.date
    }
    
    @IBAction func remindersSwitch(_ sender: UISwitch) {
        notifChoice = sender.isOn
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
    }
    
}
