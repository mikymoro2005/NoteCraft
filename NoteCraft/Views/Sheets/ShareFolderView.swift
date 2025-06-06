//
//  ShareFolderView.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024
//

import SwiftUI

// MARK: - ShareFolderView Sheet
struct ShareFolderView: View {
    let folder: Folder
    @Environment(\.dismiss) private var dismiss
    @State private var shareMessage = ""
    @State private var showingMessageComposer = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Informazioni cartella
                VStack(spacing: 16) {
                    Image(systemName: "folder.fill")
                        .font(.system(size: 60))
                        .foregroundColor(folder.color)
                    
                    Text(folder.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("\(folder.content.count) elementi")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 30)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(folder.color.opacity(0.1))
                        .stroke(folder.color.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                
                // Messaggio personalizzato
                VStack(alignment: .leading, spacing: 12) {
                    Text("Messaggio (opzionale)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextEditor(text: $shareMessage)
                        .frame(height: 100)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .font(.body)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Pulsanti di condivisione
                VStack(spacing: 12) {
                    Button(action: {
                        shareViaMessage()
                    }) {
                        HStack {
                            Image(systemName: "message.fill")
                                .font(.title3)
                            Text("Condividi via Messaggio")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue)
                        )
                    }
                    
                    Button(action: {
                        shareViaEmail()
                    }) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .font(.title3)
                            Text("Condividi via Email")
                                .font(.headline)
                        }
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Condividi Cartella")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Chiudi") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            shareMessage = "Ti condivido la cartella '\(folder.name)' da NoteCraft!"
        }
    }
    
    private func shareViaMessage() {
        let message = shareMessage.isEmpty ? "Ti condivido la cartella '\(folder.name)' da NoteCraft!" : shareMessage
        
        // Simula l'invio del messaggio
        print("Condivisione via messaggio:")
        print("Cartella: \(folder.name)")
        print("Messaggio: \(message)")
        
        // In una implementazione reale, qui apriresti l'app Messaggi
        // o useresti MessageUI framework
        
        dismiss()
    }
    
    private func shareViaEmail() {
        let message = shareMessage.isEmpty ? "Ti condivido la cartella '\(folder.name)' da NoteCraft!" : shareMessage
        
        // Simula l'invio dell'email
        print("Condivisione via email:")
        print("Cartella: \(folder.name)")
        print("Messaggio: \(message)")
        
        // In una implementazione reale, qui apriresti l'app Mail
        // o useresti MessageUI framework
        
        dismiss()
    }
}

// MARK: - Preview
struct ShareFolderView_Previews: PreviewProvider {
    static var previews: some View {
        ShareFolderView(
            folder: Folder(name: "Test Folder", color: .blue)
        )
        .previewLayout(.sizeThatFits)
    }
}