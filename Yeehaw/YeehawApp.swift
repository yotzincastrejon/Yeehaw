//
//  YeehawApp.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 3/17/21.
//

import SwiftUI
import CoreData

@main
struct YeehawApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}
