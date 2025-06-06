//
//  EditFolderView.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024
//

import SwiftUI

// MARK: - EditFolderView Sheet
struct EditFolderView: View {
    let folder: Folder
    let folderManager: FolderManager
    @Binding var editFolderName: String
    @Binding var editFolderColor: Color
    @Environment(\.dismiss) private var dismiss
    
    let availableColors: [Color] = [.blue, .green, .orange, .red, .purple, .pink, .yellow, .gray]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack(spacing: 20) {
                    // Nome cartella
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nome Cartella")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Inserisci nome cartella", text: $editFolderName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.body)
                    }
                    
                    // Selezione colore
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Colore Cartella")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 15) {
                            ForEach(availableColors, id: \.self) { color in
                                Button(action: {
                                    editFolderColor = color
                                }) {
                                    Circle()
                                        .fill(color)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Circle()
                                                .stroke(editFolderColor == color ? Color.black : Color.clear, lineWidth: 3)
                                        )
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Pulsante Salva
                Button(action: {
                    let trimmedName = editFolderName.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmedName.isEmpty {
                        folderManager.updateFolder(folder, newName: trimmedName, newColor: editFolderColor)
                        dismiss()
                    }
                }) {
                    Text("Salva Modifiche")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(editFolderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : editFolderColor)
                        )
                }
                .disabled(editFolderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Modifica Cartella")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Annulla") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct EditFolderView_Previews: PreviewProvider {
    static var previews: some View {
        EditFolderView(
            folder: Folder(name: "Test Folder", color: .blue),
            folderManager: FolderManager(),
            editFolderName: .constant("Test Folder"),
            editFolderColor: .constant(.blue)
        )
        .previewLayout(.sizeThatFits)
    }
}