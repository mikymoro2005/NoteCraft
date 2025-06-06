//
//  SidebarView.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024
//

import SwiftUI

// MARK: - SidebarView Component
struct SidebarView: View {
    @Binding var showingSettings: Bool
    @Binding var showingNewItemOptions: Bool
    @ObservedObject var folderManager: FolderManager
    let mockUserEmail: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header con avatar utente
            HStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Benvenuto")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(mockUserEmail)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            
            Divider()
                .padding(.horizontal, 16)
            
            // Menu Items
            VStack(spacing: 12) {
                // Pulsante Home/Tutti i Quaderni
                Button(action: {
                    folderManager.currentPath.removeAll()
                }) {
                    HStack {
                        Image(systemName: "house.fill")
                            .font(.title3)
                        Text("Tutti i Quaderni")
                            .font(.body)
                        Spacer()
                    }
                    .foregroundColor(.primary)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(folderManager.currentPath.isEmpty ? Color.blue.opacity(0.1) : Color.clear)
                    )
                }
                
                // Pulsante Crea Nuovo
                Button(action: {
                    showingNewItemOptions = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                        Text("Crea Nuovo")
                            .font(.body)
                        Spacer()
                    }
                    .foregroundColor(.blue)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(0.1))
                    )
                }
                
                // Pulsante Impostazioni
                Button(action: {
                    showingSettings = true
                }) {
                    HStack {
                        Image(systemName: "gearshape")
                            .font(.title3)
                        Text("Impostazioni")
                            .font(.body)
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.1))
                    )
                }
                
                Spacer()
                
                // Pulsante Log Out
                Button(action: {
                    // TODO: Implementare logout
                    print("Log out tapped")
                }) {
                    HStack {
                        Image(systemName: "arrow.right.square")
                            .font(.title3)
                        Text("Log Out")
                            .font(.body)
                        Spacer()
                    }
                    .foregroundColor(.red)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.red.opacity(0.1))
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
        }
        .navigationTitle("Menu")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(
            showingSettings: .constant(false),
            showingNewItemOptions: .constant(false),
            folderManager: FolderManager(),
            mockUserEmail: "utente@example.com"
        )
        .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}