//
//  SettingsViewController.swift
//  SleepTonight
//
//  Created by Binjia Chen on 7/23/18.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var bedtime: Bedtime?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "done":
            let bedtime = CoreDataHelper.createBedtime()
            bedtime.time = self.bedtime?.time
            
            CoreDataHelper.saveBedtime()
            
        default:
            print("Unexpected segue identifier")
        }
    }
    
    @IBAction func bedtimeValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let selectedDate = dateFormatter.string(from: sender.date)
        print(selectedDate)
        
        bedtime?.time = sender.date
        print(bedtime?.time)
    }
    
}
