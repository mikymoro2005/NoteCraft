//
//  NewItemOptionsView.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024
//

import SwiftUI

// MARK: - NewItemOptionsView Sheet
struct NewItemOptionsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var folderManager: FolderManager
    @Binding var showingNewFolderSheet: Bool
    @Binding var showingNewNotebookSheet: Bool
    
    private let options = [
        ("Nuova Cartella", "folder.fill.badge.plus", Color.blue),
        ("Nuovo Quaderno", "book.closed.fill", Color.green),
        ("Nuova Nota Rapida", "note.text.badge.plus", Color.orange),
        ("Importa PDF", "doc.fill.badge.plus", Color.red)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Cosa vuoi creare?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                
                // Layout a colonna singola
                VStack(spacing: 16) {
                    ForEach(options, id: \.0) { option in
                        Button(action: {
                            handleOptionTap(option.0)
                        }) {
                            HStack(spacing: 16) {
                                Image(systemName: option.1)
                                    .font(.system(size: 24))
                                    .foregroundColor(option.2)
                                    .frame(width: 40)
                                
                                Text(option.0)
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.05))
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .navigationTitle("Nuovo Elemento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Chiudi") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func handleOptionTap(_ optionName: String) {
        switch optionName {
        case "Nuova Cartella":
            dismiss()
            // Ritardo per evitare conflitti di layout
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showingNewFolderSheet = true
            }
        case "Nuovo Quaderno":
            dismiss()
            // Ritardo per evitare conflitti di layout
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showingNewNotebookSheet = true
            }
        default:
            // TODO: Implementare altre azioni
            print("\(optionName) tapped")
            dismiss()
        }
    }
}

// MARK: - Preview
struct NewItemOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemOptionsView(
            folderManager: FolderManager(),
            showingNewFolderSheet: .constant(false),
            showingNewNotebookSheet: .constant(false)
        )
        .previewLayout(.sizeThatFits)
    }
}