//
//  MainViewController.swift
//  SleepTonight
//
//  Created by Binjia Chen on 7/23/18.
//

import UIKit

class MainViewController: UIViewController {
    
    var bedtimes = [Bedtime]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        CoreDataHelper.reset()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bedtimes = CoreDataHelper.retrieveBedtimes()
        
        configureMainView()
    }
    
    func configureMainView() {
        let view = self.view as! MainView
        
        if let date = bedtimes[0].time {
            let time = date.convertToString()
            
            view.bedtimeLabel.text = time
        } else {
            print("Bedtime not set")
        }
        
        let prepTime = String(bedtimes[0].prepTime)
        view.bedtimeReminderLabel.text = "\(prepTime) min"
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
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
    }
}
