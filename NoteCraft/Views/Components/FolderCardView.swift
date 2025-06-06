//
//  FolderCardView.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024
//

import SwiftUI

// MARK: - FolderCardView Component
struct FolderCardView: View {
    let folder: Folder
    @State private var showingContextMenu = false
    @Binding var selectedFolder: Folder?
    @Binding var showingEditFolderSheet: Bool
    @Binding var showingMoveFolderSheet: Bool
    @Binding var showingDeleteConfirmation: Bool
    @Binding var showingShareSheet: Bool
    
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
                    .fill(folder.color)
                    .frame(width: 4, height: 160)
                    .padding(.leading, 4)
                Spacer()
            }
            
            // Contenuto principale
            VStack(spacing: 12) {
                // Icona cartella
                Image(systemName: "folder.fill")
                    .font(.system(size: 40))
                    .foregroundColor(folder.color)
                
                // Nome cartella
                Text(folder.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 12)
                
                // Numero di elementi
                Text("\(folder.content.count) elementi")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 8) // Spazio per la striscia colorata
            
            // Menu tre puntini integrato nell'angolo superiore destro
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showingContextMenu = true
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                            .padding(6)
                    }
                    .padding(.top, 6)
                    .padding(.trailing, 6)
                }
                Spacer()
            }
        }
        .confirmationDialog("Opzioni Cartella", isPresented: $showingContextMenu, titleVisibility: .visible) {
            Button("Modifica") {
                selectedFolder = folder
                showingEditFolderSheet = true
            }
            
            Button("Sposta") {
                selectedFolder = folder
                showingMoveFolderSheet = true
            }
            
            Button("Condividi") {
                selectedFolder = folder
                showingShareSheet = true
            }
            
            Button("Elimina", role: .destructive) {
                selectedFolder = folder
                showingDeleteConfirmation = true
            }
            
            Button("Annulla", role: .cancel) { }
        }
    }
    

}

// MARK: - Preview
struct FolderCardView_Previews: PreviewProvider {
    static var previews: some View {
        FolderCardView(
            folder: Folder(name: "Cartella di Esempio", color: .blue),
            selectedFolder: .constant(nil),
            showingEditFolderSheet: .constant(false),
            showingMoveFolderSheet: .constant(false),
            showingDeleteConfirmation: .constant(false),
            showingShareSheet: .constant(false)
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}