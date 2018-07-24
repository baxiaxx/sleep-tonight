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
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        bedtimes = CoreDataHelper.retrieveBedtimes()
        
        let view = self.view as! MainView
        
        print(bedtimes)
        //view.bedtimeLabel.text = bedtimes[0].bedtime?.convertToString()
    }
}
