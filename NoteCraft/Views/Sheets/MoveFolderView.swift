//
//  MoveFolderView.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024
//

import SwiftUI

// MARK: - MoveFolderView Sheet
struct MoveFolderView: View {
    let folder: Folder
    let folderManager: FolderManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDestination: [Folder] = []
    @State private var showingMoveError = false
    
    var availableFolders: [Folder] {
        return folderManager.getAllFolders().filter { $0.id != folder.id }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Informazioni cartella da spostare
                VStack(spacing: 12) {
                    Text("Spostare la cartella:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "folder.fill")
                            .font(.title2)
                            .foregroundColor(folder.color)
                        
                        Text(folder.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(folder.color.opacity(0.1))
                            .stroke(folder.color.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                
                Divider()
                
                // Lista destinazioni
                VStack(alignment: .leading, spacing: 12) {
                    Text("Seleziona destinazione:")
                        .font(.headline)
                        .padding(.horizontal, 20)
                    
                    ScrollView {
                        VStack(spacing: 8) {
                            // Opzione "Cartella principale"
                            Button(action: {
                                selectedDestination = []
                            }) {
                                HStack {
                                    Image(systemName: "house.fill")
                                        .font(.title3)
                                        .foregroundColor(.blue)
                                    
                                    Text("Cartella Principale")
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    if selectedDestination.isEmpty {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedDestination.isEmpty ? Color.blue.opacity(0.1) : Color.clear)
                                )
                            }
                            
                            // Cartelle disponibili
                            ForEach(availableFolders) { availableFolder in
                                Button(action: {
                                    selectedDestination = [availableFolder]
                                }) {
                                    HStack {
                                        Image(systemName: "folder.fill")
                                            .font(.title3)
                                            .foregroundColor(availableFolder.color)
                                        
                                        Text(availableFolder.name)
                                            .font(.body)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        if selectedDestination.first?.id == availableFolder.id {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(selectedDestination.first?.id == availableFolder.id ? Color.blue.opacity(0.1) : Color.clear)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                Spacer()
                
                // Pulsante Sposta
                Button(action: {
                    let success = folderManager.moveFolder(folder, to: selectedDestination)
                    if success {
                        dismiss()
                    } else {
                        showingMoveError = true
                    }
                }) {
                    Text("Sposta Cartella")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Sposta Cartella")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Annulla") {
                        dismiss()
                    }
                }
            }
            .alert("Spostamento Non Valido", isPresented: $showingMoveError) {
                Button("OK") { }
            } message: {
                Text("Non è possibile spostare una cartella all'interno di se stessa o delle sue sottocartelle.")
            }
        }
    }
}

// MARK: - Preview
struct MoveFolderView_Previews: PreviewProvider {
    static var previews: some View {
        MoveFolderView(
            folder: Folder(name: "Test Folder", color: .blue),
            folderManager: FolderManager()
        )
        .previewLayout(.sizeThatFits)
    }
}