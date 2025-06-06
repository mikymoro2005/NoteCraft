//
//  NewFolderCreationView.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024
//

import SwiftUI

// MARK: - NewFolderCreationView Sheet
struct NewFolderCreationView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var folderManager: FolderManager
    @Binding var newFolderName: String
    @Binding var selectedFolderColor: Color
    
    private let availableColors: [Color] = [
        .red, .blue, .green, .yellow, .purple, .orange, .brown, .gray
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Crea Nuova Cartella")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                
                // Campo nome cartella
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nome Cartella")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Inserisci il nome della cartella", text: $newFolderName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled()
                }
                .padding(.horizontal, 20)
                
                // Selezione colore
                VStack(alignment: .leading, spacing: 16) {
                    Text("Scegli Colore")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                        ForEach(availableColors, id: \.self) { color in
                            Button(action: {
                                selectedFolderColor = color
                            }) {
                                Circle()
                                    .fill(color)
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Circle()
                                            .stroke(selectedFolderColor == color ? Color.primary : Color.clear, lineWidth: 3)
                                    )
                                    .scaleEffect(selectedFolderColor == color ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: selectedFolderColor)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Pulsante Salva
                Button(action: {
                    let trimmedName = newFolderName.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmedName.isEmpty {
                        folderManager.addFolder(name: trimmedName, color: selectedFolderColor)
                        newFolderName = ""
                        selectedFolderColor = .blue
                        dismiss()
                    }
                }) {
                    Text("Salva")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(newFolderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : selectedFolderColor)
                        )
                }
                .disabled(newFolderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Nuova Cartella")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Annulla") {
                        newFolderName = ""
                        selectedFolderColor = .blue
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct NewFolderCreationView_Previews: PreviewProvider {
    static var previews: some View {
        NewFolderCreationView(
            folderManager: FolderManager(),
            newFolderName: .constant(""),
            selectedFolderColor: .constant(.blue)
        )
        .previewLayout(.sizeThatFits)
    }
}