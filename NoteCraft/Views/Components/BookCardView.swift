//
//  BookCardView.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024
//

import SwiftUI

// MARK: - BookCardView Component (Card "Crea Nuovo")
struct BookCardView: View {
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
            
            // Contenuto principale
            VStack(spacing: 12) {
                // Simbolo "+" centrato
                Image(systemName: "plus")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.blue)
                
                // Testo "Crea Nuovo"
                Text("Crea Nuovo")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                // Testo descrittivo
                Text("Aggiungi elemento")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Preview
struct BookCardView_Previews: PreviewProvider {
    static var previews: some View {
        BookCardView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}