//
//  BedtimeReminderOptionsTableViewCell.swift
//  SleepTonight
//
//  Created by Selena Sui on 7/25/18.
//

import UIKit

class BedtimeReminderOptionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var optionLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        selectionStyle = .none
    }
    
}
