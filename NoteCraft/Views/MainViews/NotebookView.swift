//
//  NotebookView.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024
//

import SwiftUI

/// Vista principale per l'interazione con un quaderno a schermo intero
struct NotebookView: View {
    /// Il quaderno specifico che è stato aperto
    let notebook: Notebook
    
    /// Environment per gestire la dismissione della vista
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .top) {
            // Il foglio bianco che occupa tutto lo schermo
            Color.white
                .ignoresSafeArea()
            
            // Header personalizzato sovrapposto al foglio
            NotebookHeaderView(notebook: notebook)
                .padding(.horizontal)
        }
    }
}

// MARK: - Preview
struct NotebookView_Previews: PreviewProvider {
    static var previews: some View {
        NotebookView(
            notebook: Notebook(
                name: "Appunti di Storia",
                coverColor: .blue,
                paperType: .lines
            )
        )
    }
}