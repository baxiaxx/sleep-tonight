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
    
    let options: [Int: [String: TimeInterval]] = [0: ["None" : 0.0 * 60],
                                                  1: ["1 min" : 1.0 * 60],
                                                  2: ["5 min" : 5.0 * 60],
                                                  3: ["10 min" : 10.0 * 60],
                                                  4: ["15 min" : 15.0 * 60],
                                                  5: ["30 min" : 30.0 * 60],
                                                  6: ["45 min" : 45.0 * 60],
                                                  7: ["60 min" : 60.0 * 60]]
    
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
        
        let option = options[indexPath.row]
        
        cell.optionLabel.text = Array(option!.keys).first
        
        if bedtime?.prepTime == option!.values.first {
            cell.accessoryType = .checkmark
            cell.isSelected = true
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
        
        let option = options[indexPath.row]
        let timeInterval = Array(option!.values).first
        bedtime?.prepTime = timeInterval!
        
        CoreDataHelper.saveBedtime()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
    }
}

extension BedtimeReminderOptionsViewController: UITableViewDelegate {
    
}
