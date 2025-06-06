//
//  GridUtilities.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024
//

import SwiftUI

// MARK: - Grid Utilities

/// Calcola le colonne adattive per una griglia responsiva
/// - Parameter geometry: Il GeometryProxy per ottenere le dimensioni disponibili
/// - Returns: Array di GridItem configurati per la griglia responsiva
func adaptiveColumns(for geometry: GeometryProxy) -> [GridItem] {
    let availableWidth = geometry.size.width - 40 // Padding orizzontale
    let cardWidth: CGFloat = 160 // Larghezza aggiornata per coerenza con le nuove card
    let spacing: CGFloat = 30
    
    // Calcola il numero di colonne che possono entrare
    let columnsCount = max(1, Int((availableWidth + spacing) / (cardWidth + spacing)))
    
    return Array(repeating: GridItem(.flexible(minimum: cardWidth, maximum: cardWidth), spacing: spacing), count: columnsCount)
}