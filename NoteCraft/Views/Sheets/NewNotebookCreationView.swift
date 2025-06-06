//
//  NewNotebookCreationView.swift
//  NoteCraft
//
//  Created by NoteCraft on 2024.
//

import SwiftUI

// MARK: - NewNotebookCreationView Sheet
struct NewNotebookCreationView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var folderManager: FolderManager
    
    @State private var notebookName: String = ""
    @State private var selectedColor: Color = .blue
    @State private var selectedPaperType: PaperType = .lines
    
    // Colori predefiniti per la copertina
    private let coverColors: [Color] = [
        .blue, .green, .red, .orange, .purple, .pink,
        .yellow, .cyan, .mint, .indigo, .brown, .gray
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "book.closed.fill")
                            .font(.system(size: 48))
                            .foregroundColor(selectedColor)
                        
                        Text("Crea Nuovo Quaderno")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .padding(.top, 20)
                    
                    // Nome del quaderno
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nome del Quaderno")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Inserisci il nome del quaderno", text: $notebookName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.body)
                    }
                    .padding(.horizontal, 20)
                    
                    // Selezione colore copertina
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Colore Copertina")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                            ForEach(coverColors, id: \.self) { color in
                                Button(action: {
                                    selectedColor = color
                                }) {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(color.gradient)
                                        .frame(width: 60, height: 80)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(selectedColor == color ? Color.primary : Color.clear, lineWidth: 3)
                                        )
                                        .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)
                                        .scaleEffect(selectedColor == color ? 1.05 : 1.0)
                                        .animation(.easeInOut(duration: 0.2), value: selectedColor)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Selezione tipo di carta
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Tipo di Carta")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                            ForEach(PaperType.allCases, id: \.self) { paperType in
                                Button(action: {
                                    selectedPaperType = paperType
                                }) {
                                    VStack(spacing: 12) {
                                        // Anteprima immagine del tipo di carta
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.white)
                                                .frame(width: 80, height: 80)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                                )
                                            
                                            // Immagine di anteprima del tipo di carta
                                            Image(paperTypeImageName(for: paperType))
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 70, height: 70)
                                                .clipped()
                                        }
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(selectedPaperType == paperType ? selectedColor : Color.clear, lineWidth: 3)
                                        )
                                        
                                        // Nome del tipo di carta
                                        Text(paperType.rawValue)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(selectedPaperType == paperType ? selectedColor : .primary)
                                    }
                                    .scaleEffect(selectedPaperType == paperType ? 1.05 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: selectedPaperType)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 20)
                }
            }
            .navigationTitle("Nuovo Quaderno")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annulla") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salva") {
                        saveNotebook()
                    }
                    .disabled(notebookName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func saveNotebook() {
        let trimmedName = notebookName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            return
        }
        
        // Aggiungi il quaderno tramite FolderManager
        folderManager.addNotebook(
            name: trimmedName,
            coverColor: selectedColor,
            paperType: selectedPaperType
        )
        
        // Chiudi il foglio
        dismiss()
    }
    
    /// Restituisce il nome dell'immagine per ogni tipo di carta
    private func paperTypeImageName(for paperType: PaperType) -> String {
        switch paperType {
        case .lines:
            return "paper_lined_preview"
        case .grid:
            return "paper_grid_preview"
        case .blank:
            return "paper_blank_preview"
        case .dots:
            return "paper_dotted_preview"
        }
    }
}

// MARK: - Preview
struct NewNotebookCreationView_Previews: PreviewProvider {
    static var previews: some View {
        NewNotebookCreationView(
            folderManager: FolderManager()
        )
        .previewLayout(.sizeThatFits)
    }
}