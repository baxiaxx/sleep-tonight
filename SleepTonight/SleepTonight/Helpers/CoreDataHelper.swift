//
//  CoreDataHelper.swift
//  SleepTonight
//
//  Created by Binjia Chen on 7/24/18.
//

import Foundation
import UIKit
import CoreData

struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static func createBedtime() -> Bedtime {
        let bedtime = NSEntityDescription.insertNewObject(forEntityName: "Bedtime", into: context) as! Bedtime
        
        return bedtime
    }
    
    static func saveBedtime() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func deleteBedtime(bedtime: Bedtime) {
        context.delete(bedtime)
        
        saveBedtime()
    }
    
    static func retrieveBedtimes() -> [Bedtime] {
        do {
            let fetchRequest = NSFetchRequest<Bedtime>(entityName: "Bedtime")
            let results = try context.fetch(fetchRequest)
            
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            
            return []
        }
    }
    
    static func reset() {
        context.reset()
    }
}
