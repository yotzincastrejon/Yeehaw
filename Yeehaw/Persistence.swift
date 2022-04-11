//
//  Persistence.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 4/8/22.
//

import Foundation
import CoreData
import CloudKit

struct PersistenceController {
    static var shared = PersistenceController()
    
    let container: NSPersistentCloudKitContainer
    
    static var preview: PersistenceController = {
        let arrayOfNames = ["Duo Trap", "Tacx Neo 2T", "Wahoo Kickr", "Tickr"]
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<6 {
            let newItem = SavedDevice(context: viewContext)
            newItem.deviceName = arrayOfNames.randomElement()
            newItem.deviceID = UUID().uuidString
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    static var singular: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let newItem = SavedDevice(context: viewContext)
        newItem.deviceName = "Test Name"
        newItem.deviceID = UUID().uuidString
        newItem.timestamp = Date()
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "SavedDevices")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
    }
}
