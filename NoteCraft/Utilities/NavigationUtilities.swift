//
//  NavigationUtilities.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024.
//

import SwiftUI

// ObservableObject per gestire la navigazione
class NavigationManager: ObservableObject {
    @Published var shouldPopToRoot = false
    
    func popToRoot() {
        shouldPopToRoot = true
    }
    
    func resetPopToRoot() {
        shouldPopToRoot = false
    }
}

// Environment key per il NavigationManager
struct NavigationManagerKey: EnvironmentKey {
    static let defaultValue = NavigationManager()
}

extension EnvironmentValues {
    var navigationManager: NavigationManager {
        get { self[NavigationManagerKey.self] }
        set { self[NavigationManagerKey.self] = newValue }
    }
}