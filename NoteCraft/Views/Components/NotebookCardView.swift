//
//  NotebookCardView.swift
//  NoteCraft
//
//  Created by NoteCraft on 2024.
//

import SwiftUI

// MARK: - NotebookCardView Component
struct NotebookCardView: View {
    let notebook: Notebook
    
    var body: some View {
        ZStack {
            // Sfondo principale neutro
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .frame(width: 160, height: 180)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
            
            // Striscia colorata verticale sul bordo sinistro
            HStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(notebook.coverColor)
                    .frame(width: 4, height: 160)
                    .padding(.leading, 4)
                Spacer()
            }
            
            // Contenuto principale
            VStack(spacing: 12) {
                // Icona del quaderno
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 40))
                    .foregroundColor(notebook.coverColor)
                
                // Nome del quaderno
                Text(notebook.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 12)
                
                // Tipo di carta come sottotitolo con icona
                HStack(spacing: 4) {
                    Image(systemName: notebook.paperType.icon)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    Text(notebook.paperType.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.leading, 8) // Spazio per la striscia colorata
        }
    }
    

}

// MARK: - Preview
struct NotebookCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            // Preview con un singolo quaderno
            NotebookCardView(notebook: Notebook.example)
                .frame(width: 120)
            
            // Preview con diversi tipi di quaderni
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                ForEach(Notebook.examples, id: \.id) { notebook in
                    NotebookCardView(notebook: notebook)
                }
            }
            .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}