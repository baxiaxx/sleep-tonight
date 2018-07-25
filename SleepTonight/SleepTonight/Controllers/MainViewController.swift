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
        
        bedtimes = CoreDataHelper.retrieveBedtimes()
        for bedtime in bedtimes {
            CoreDataHelper.deleteBedtime(bedtime: bedtime)
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        bedtimes = CoreDataHelper.retrieveBedtimes()
        
        let view = self.view as! MainView
        
        print(bedtimes[0].time)
        view.bedtimeLabel.text = bedtimes[0].time?.convertToString()
    }
}
