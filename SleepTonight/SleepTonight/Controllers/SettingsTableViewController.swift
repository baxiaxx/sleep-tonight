//
//  SettingsTableViewController.swift
//  SleepTonight
//
//  Created by Binjia Chen on 7/25/18.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var bedtime: Bedtime?
    
    var timePicked: Date?
    
    @IBOutlet weak var bedtimePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDatePicker()
    }
    
    func configureDatePicker() {
        guard let time = bedtime?.time else { return }
        bedtimePicker.date = time
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "doneWithSettings":
            bedtime?.time = timePicked ?? Date()
            
            CoreDataHelper.saveBedtime()
            
        case "displayReminderOptions":
            let destination = segue.destination as! BedtimeReminderOptionsViewController
            
            destination.bedtime = self.bedtime
            
        default:
            print("Unexpected segue identifier")
        }
    }
    
    @IBAction func bedtimePickerValueChanged(_ sender: UIDatePicker) {
        timePicked = sender.date
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
    }
    
}
