//
//  BreadcrumbsView.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024
//

import SwiftUI

// MARK: - BreadcrumbsView Component
struct BreadcrumbsView: View {
    @ObservedObject var folderManager: FolderManager
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // Home button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        folderManager.navigateToPath(upTo: -1)
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "house.fill")
                        Text("HOME")
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(0.1))
                    )
                }
                
                // Breadcrumb items
                ForEach(Array(folderManager.currentPath.enumerated()), id: \.element.id) { index, folder in
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                folderManager.navigateToPath(upTo: index)
                            }
                        }) {
                            Text(folder.name.uppercased())
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.blue.opacity(0.1))
                                )
                        }
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

// MARK: - Preview
struct BreadcrumbsView_Previews: PreviewProvider {
    static var previews: some View {
        let folderManager = FolderManager()
        folderManager.rootFolders = [
            Folder(name: "Cartella 1", color: .blue),
            Folder(name: "Cartella 2", color: .green)
        ]
        folderManager.currentPath = [
            Folder(name: "Cartella 1", color: .blue),
            Folder(name: "Sottocartella", color: .orange)
        ]
        
        return BreadcrumbsView(folderManager: folderManager)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}