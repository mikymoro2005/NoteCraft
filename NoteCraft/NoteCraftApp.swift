//
//  NoteCraftApp.swift
//  NoteCraft
//
//  Created by Michele Moretti on 05/06/25.
//

import SwiftUI
import CoreData
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift

// AppDelegate per gestire i callback di Google Sign-In
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    // FONDAMENTALE: Gestisce l'URL di callback per Google Sign-In
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct NoteCraftApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared
    @StateObject private var navigationManager = NavigationManager()

    var body: some Scene {
        WindowGroup {
            // Utilizziamo NavigationStack per una navigazione moderna
            NavigationStack {
                WelcomeView()
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environment(\.navigationManager, navigationManager)
        }
    }
}
