//
//  BedtimeReminderOptionsViewController.swift
//  SleepTonight
//
//  Created by Binjia Chen on 7/25/18.
//

import UIKit

typealias TimeInterval = Double

class BedtimeReminderOptionsViewController: UIViewController {
    
    var bedtime: Bedtime?
    
    @IBOutlet weak var tableView: UITableView!
    
    let options = ["None", "15 min", "30 min", "45 min", "60 min"]
    let timeIntervals: [TimeInterval] = [0.0, 15.0, 30.0, 45.0, 60.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
}

extension BedtimeReminderOptionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BedtimeReminderOption", for: indexPath) as! BedtimeReminderOptionsTableViewCell
        
        cell.optionLabel.text = options[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
        
        let timeInterval = timeIntervals[indexPath.row]
        bedtime?.prepTime = timeInterval
        
        CoreDataHelper.saveBedtime()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
    }
}

extension BedtimeReminderOptionsViewController: UITableViewDelegate {
    
}
