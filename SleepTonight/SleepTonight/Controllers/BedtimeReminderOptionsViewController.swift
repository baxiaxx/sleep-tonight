//
//  BedtimeReminderOptionsViewController.swift
//  SleepTonight
//
//  Created by Binjia Chen on 7/25/18.
//

import UIKit

class BedtimeReminderOptionsViewController: UIViewController {
    
    var bedtime: Bedtime?
    
    @IBOutlet weak var tableView: UITableView!
    
    let options: [String : TimeInterval] = ["None" : 0.0,
                                         "15 min" : 15.0,
                                         "30 min" : 30.0,
                                         "45 min" : 45.0,
                                         "60 min" : 60.0]
    
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
        
        let option = Array(options)[indexPath.row]
        
        cell.optionLabel.text = option.key
        
        if bedtime?.prepTime == option.value {
            cell.accessoryType = .checkmark
            cell.isSelected = true
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
        
        let option = Array(options)[indexPath.row]
        
        let timeInterval = option.value
        bedtime?.prepTime = timeInterval
        
        CoreDataHelper.saveBedtime()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
    }
}

extension BedtimeReminderOptionsViewController: UITableViewDelegate {
    
}
