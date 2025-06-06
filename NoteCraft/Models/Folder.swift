//
//  Folder.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024
//

import Foundation
import SwiftUI

// MARK: - Folder Model
struct Folder: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var color: Color
    var content: [Folder] = []
    var notebooks: [Notebook] = []
    
    static func == (lhs: Folder, rhs: Folder) -> Bool {
        lhs.id == rhs.id
    }
}