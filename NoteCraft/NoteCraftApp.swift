//
//  NoteCraftApp.swift
//  NoteCraft
//
//  Created by Michele Moretti on 05/06/25.
//

import SwiftUI

@main
struct NoteCraftApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
