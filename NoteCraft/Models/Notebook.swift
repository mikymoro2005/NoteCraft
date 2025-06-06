//
//  Notebook.swift
//  NoteCraft
//
//  Created by NoteCraft on 2024.
//

import Foundation
import SwiftUI

/// Enum che definisce i tipi di carta disponibili per un quaderno
enum PaperType: String, CaseIterable, Identifiable {
    case lines = "Linee"
    case grid = "Griglia"
    case blank = "Vuoto"
    case dots = "Puntini"
    
    var id: String { self.rawValue }
    
    /// Icona associata al tipo di carta
    var icon: String {
        switch self {
        case .lines:
            return "text.alignleft"
        case .grid:
            return "grid"
        case .blank:
            return "rectangle"
        case .dots:
            return "circle.grid.3x3"
        }
    }
}

/// Modello che rappresenta un quaderno (taccuino)
struct Notebook: Identifiable, Equatable {
    /// Identificatore univoco del quaderno
    let id: UUID
    
    /// Nome del quaderno
    var name: String
    
    /// Colore della copertina del quaderno
    var coverColor: Color
    
    /// Tipo di carta del quaderno
    var paperType: PaperType
    
    /// Data di creazione del quaderno
    let createdAt: Date
    
    /// Inizializzatore per creare un nuovo quaderno
    /// - Parameters:
    ///   - name: Nome del quaderno
    ///   - coverColor: Colore della copertina
    ///   - paperType: Tipo di carta
    init(name: String, coverColor: Color, paperType: PaperType) {
        self.id = UUID()
        self.name = name
        self.coverColor = coverColor
        self.paperType = paperType
        self.createdAt = Date()
    }
    
    /// Implementazione di Equatable
    static func == (lhs: Notebook, rhs: Notebook) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Preview Helper
extension Notebook {
    /// Quaderno di esempio per le preview
    static let example = Notebook(
        name: "Il mio primo quaderno",
        coverColor: .blue,
        paperType: .lines
    )
    
    /// Array di quaderni di esempio per le preview
    static let examples = [
        Notebook(name: "Appunti Università", coverColor: .blue, paperType: .lines),
        Notebook(name: "Schizzi e Disegni", coverColor: .green, paperType: .blank),
        Notebook(name: "Matematica", coverColor: .red, paperType: .grid),
        Notebook(name: "Idee Creative", coverColor: .purple, paperType: .dots)
    ]
}