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
        
        bedtimes = CoreDataHelper.retrieveBedtimes()
        
        let view = self.view as! MainView
        
        view.bedtimeLabel.text = bedtimes[0].time?.convertToString()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "displaySettings":
            let bedtime = bedtimes[0]
            
            let destination = segue.destination as! SettingsViewController
            
            destination.bedtime = bedtime
        default:
            print("Unexpected segue identifier")
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        bedtimes = CoreDataHelper.retrieveBedtimes()
    }
}
