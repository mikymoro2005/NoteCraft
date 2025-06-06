//
//  NotebookHeaderView.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024
//

import SwiftUI

/// Header personalizzato per la vista del quaderno
struct NotebookHeaderView: View {
    /// Il quaderno corrente
    let notebook: Notebook
    
    /// Environment per gestire la dismissione della vista
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            // MARK: - Sezione Sinistra (Titolo e Indietro)
            HStack(spacing: 12) {
                // Pulsante per tornare indietro
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                
                // Titolo del quaderno
                Text(notebook.name)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // MARK: - Sezione Centro (Strumenti)
            HStack(spacing: 16) {
                // Matita
                Button(action: {
                    // TODO: Implementare logica matita
                }) {
                    Image(systemName: "pencil")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                
                // Penna
                Button(action: {
                    // TODO: Implementare logica penna
                }) {
                    Image(systemName: "pen.fill")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                
                // Evidenziatore
                Button(action: {
                    // TODO: Implementare logica evidenziatore
                }) {
                    Image(systemName: "highlighter")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                
                // Gomma
                Button(action: {
                    // TODO: Implementare logica gomma
                }) {
                    Image(systemName: "eraser.fill")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                
                // Forme
                Button(action: {
                    // TODO: Implementare logica forme
                }) {
                    Image(systemName: "square.on.circle")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
            }
            
            Spacer()
            
            // MARK: - Sezione Destra (Azioni)
            HStack(spacing: 16) {
                // AI
                Button(action: {
                    // TODO: Implementare funzionalità AI
                }) {
                    Image(systemName: "sparkles")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                
                // Condividi
                Button(action: {
                    // TODO: Implementare condivisione
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                
                // Impostazioni
                Button(action: {
                    // TODO: Implementare impostazioni
                }) {
                    Image(systemName: "gearshape")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Color(.systemBackground)
                .opacity(0.95)
                .background(.ultraThinMaterial)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Preview
struct NotebookHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NotebookHeaderView(
                notebook: Notebook(
                    name: "Appunti di Storia",
                    coverColor: .blue,
                    paperType: .lines
                )
            )
            .padding()
            
            Spacer()
        }
        .background(Color.gray.opacity(0.1))
    }
}