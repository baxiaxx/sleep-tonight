//
//  SettingsViewController.swift
//  SleepTonight
//
//  Created by Binjia Chen on 7/23/18.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var bedtime: Bedtime?
    
    var timePicked: Date?
    
    @IBOutlet weak var bedtimePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "done":
            bedtime?.time = timePicked ?? Date()
            
            CoreDataHelper.saveBedtime()
            
        default:
            print("Unexpected segue identifier")
        }
    }
    
    @IBAction func bedtimePickerValueChanged(_ sender: UIDatePicker) {
        timePicked = sender.date
    }
    
}
