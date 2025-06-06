//
//  FolderManager.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024
//

import Foundation
import SwiftUI
import Combine

// MARK: - Folder Manager
class FolderManager: ObservableObject {
    @Published var rootFolders: [Folder] = []
    @Published var rootLevelNotebooks: [Notebook] = []
    @Published var currentPath: [Folder] = []
    
    var currentFolders: [Folder] {
        if currentPath.isEmpty {
            return rootFolders
        } else {
            return currentPath.last?.content ?? []
        }
    }
    
    /// Restituisce i quaderni della cartella attualmente visualizzata
    var currentNotebooks: [Notebook] {
        if currentPath.isEmpty {
            // Se siamo al livello root, restituiamo solo i quaderni di primo livello
            return rootLevelNotebooks
        } else {
            return currentPath.last?.notebooks ?? []
        }
    }
    
    func addFolder(name: String, color: Color) {
        let newFolder = Folder(name: name, color: color)
        
        if currentPath.isEmpty {
            rootFolders.append(newFolder)
        } else {
            // Aggiorna ricorsivamente la struttura delle cartelle
            rootFolders = updateFolderContentRecursive(folders: rootFolders, targetPath: currentPath, newFolder: newFolder)
            // Aggiorna il currentPath con i nuovi riferimenti
            updateCurrentPath()
        }
    }
    
    /// Aggiunge un nuovo quaderno alla cartella attualmente selezionata
    /// - Parameters:
    ///   - name: Nome del quaderno
    ///   - coverColor: Colore della copertina
    ///   - paperType: Tipo di carta
    func addNotebook(name: String, coverColor: Color, paperType: PaperType) {
        let newNotebook = Notebook(name: name, coverColor: coverColor, paperType: paperType)
        
        if currentPath.isEmpty {
            // Se siamo al livello root, aggiungiamo il quaderno direttamente ai quaderni di primo livello
            rootLevelNotebooks.append(newNotebook)
        } else {
            // Aggiorna ricorsivamente la struttura delle cartelle per aggiungere il quaderno
            rootFolders = updateFolderNotebooksRecursive(folders: rootFolders, targetPath: currentPath, newNotebook: newNotebook)
            // Aggiorna il currentPath con i nuovi riferimenti
            updateCurrentPath()
        }
    }
    
    private func updateFolderContentRecursive(folders: [Folder], targetPath: [Folder], newFolder: Folder) -> [Folder] {
        guard !targetPath.isEmpty else { return folders }
        
        let targetId = targetPath[0].id
        var updatedFolders = folders
        
        for i in 0..<updatedFolders.count {
            if updatedFolders[i].id == targetId {
                if targetPath.count == 1 {
                    // Questa è la cartella di destinazione finale
                    var updatedFolder = updatedFolders[i]
                    updatedFolder.content.append(newFolder)
                    updatedFolders[i] = updatedFolder
                } else {
                    // Continua ricorsivamente nel percorso
                    let remainingPath = Array(targetPath.dropFirst())
                    var updatedFolder = updatedFolders[i]
                    updatedFolder.content = updateFolderContentRecursive(
                        folders: updatedFolder.content,
                        targetPath: remainingPath,
                        newFolder: newFolder
                    )
                    updatedFolders[i] = updatedFolder
                }
                break
            }
        }
        
        return updatedFolders
    }
    
    /// Metodo helper per aggiornare ricorsivamente i quaderni in una cartella specifica
    private func updateFolderNotebooksRecursive(folders: [Folder], targetPath: [Folder], newNotebook: Notebook) -> [Folder] {
        guard !targetPath.isEmpty else { return folders }
        
        let targetId = targetPath[0].id
        var updatedFolders = folders
        
        for i in 0..<updatedFolders.count {
            if updatedFolders[i].id == targetId {
                if targetPath.count == 1 {
                    // Questa è la cartella di destinazione finale
                    var updatedFolder = updatedFolders[i]
                    updatedFolder.notebooks.append(newNotebook)
                    updatedFolders[i] = updatedFolder
                } else {
                    // Continua ricorsivamente nel percorso
                    let remainingPath = Array(targetPath.dropFirst())
                    var updatedFolder = updatedFolders[i]
                    updatedFolder.content = updateFolderNotebooksRecursive(
                        folders: updatedFolder.content,
                        targetPath: remainingPath,
                        newNotebook: newNotebook
                    )
                    updatedFolders[i] = updatedFolder
                }
                break
            }
        }
        
        return updatedFolders
    }
    
    private func updateCurrentPath() {
        // Ricostruisci il currentPath con i riferimenti aggiornati dalla struttura rootFolders
        var newPath: [Folder] = []
        var currentFolders = rootFolders
        
        for pathFolder in currentPath {
            for folder in currentFolders {
                if folder.id == pathFolder.id {
                    newPath.append(folder)
                    currentFolders = folder.content
                    break
                }
            }
        }
        
        currentPath = newPath
    }
    
    func navigateToFolder(_ folder: Folder) {
        currentPath.append(folder)
    }
    
    func navigateToPath(upTo index: Int) {
        if index < 0 {
            currentPath.removeAll()
        } else if index < currentPath.count {
            currentPath = Array(currentPath.prefix(index + 1))
        }
    }
    
    // MARK: - Folder Operations
    
    func updateFolder(_ folder: Folder, newName: String, newColor: Color) {
        var updatedFolder = folder
        updatedFolder.name = newName
        updatedFolder.color = newColor
        
        rootFolders = updateFolderRecursive(folders: rootFolders, targetFolder: updatedFolder)
        updateCurrentPath()
    }
    
    func deleteFolder(_ folder: Folder) {
        rootFolders = deleteFolderRecursive(folders: rootFolders, targetId: folder.id)
        updateCurrentPath()
    }
    
    func moveFolder(_ folder: Folder, to destinationPath: [Folder]) -> Bool {
        // Verifica se si sta tentando di spostare una cartella in una sua sottocartella
        if !destinationPath.isEmpty {
            let destinationFolder = destinationPath.last!
            if isSubfolderOf(destinationFolder, in: folder) {
                return false // Spostamento non valido
            }
        }
        
        // Prima rimuovi la cartella dalla posizione attuale
        rootFolders = deleteFolderRecursive(folders: rootFolders, targetId: folder.id)
        
        // Poi aggiungila nella nuova posizione
        if destinationPath.isEmpty {
            rootFolders.append(folder)
        } else {
            rootFolders = addFolderToPathRecursive(folders: rootFolders, targetPath: destinationPath, folderToAdd: folder)
        }
        
        updateCurrentPath()
        return true // Spostamento riuscito
    }
    
    func getAllFolders() -> [Folder] {
        return getAllFoldersRecursive(folders: rootFolders)
    }
    
    // MARK: - Private Helper Methods
    
    private func updateFolderRecursive(folders: [Folder], targetFolder: Folder) -> [Folder] {
        var updatedFolders = folders
        
        for i in 0..<updatedFolders.count {
            if updatedFolders[i].id == targetFolder.id {
                var updated = targetFolder
                updated.content = updatedFolders[i].content // Mantieni il contenuto esistente
                updatedFolders[i] = updated
            } else {
                var folder = updatedFolders[i]
                folder.content = updateFolderRecursive(folders: folder.content, targetFolder: targetFolder)
                updatedFolders[i] = folder
            }
        }
        
        return updatedFolders
    }
    
    private func deleteFolderRecursive(folders: [Folder], targetId: UUID) -> [Folder] {
        var updatedFolders: [Folder] = []
        
        for folder in folders {
            if folder.id != targetId {
                var updatedFolder = folder
                updatedFolder.content = deleteFolderRecursive(folders: folder.content, targetId: targetId)
                updatedFolders.append(updatedFolder)
            }
        }
        
        return updatedFolders
    }
    
    private func addFolderToPathRecursive(folders: [Folder], targetPath: [Folder], folderToAdd: Folder) -> [Folder] {
        guard !targetPath.isEmpty else { return folders }
        
        let targetId = targetPath[0].id
        var updatedFolders = folders
        
        for i in 0..<updatedFolders.count {
            if updatedFolders[i].id == targetId {
                if targetPath.count == 1 {
                    var updatedFolder = updatedFolders[i]
                    updatedFolder.content.append(folderToAdd)
                    updatedFolders[i] = updatedFolder
                } else {
                    let remainingPath = Array(targetPath.dropFirst())
                    var updatedFolder = updatedFolders[i]
                    updatedFolder.content = addFolderToPathRecursive(
                        folders: updatedFolder.content,
                        targetPath: remainingPath,
                        folderToAdd: folderToAdd
                    )
                    updatedFolders[i] = updatedFolder
                }
                break
            }
        }
        
        return updatedFolders
    }
    
    private func getAllFoldersRecursive(folders: [Folder]) -> [Folder] {
        var allFolders: [Folder] = []
        
        for folder in folders {
            allFolders.append(folder)
            allFolders.append(contentsOf: getAllFoldersRecursive(folders: folder.content))
        }
        
        return allFolders
    }
    
    private func isSubfolderOf(_ targetFolder: Folder, in parentFolder: Folder) -> Bool {
        // Verifica se targetFolder è uguale a parentFolder
        if targetFolder.id == parentFolder.id {
            return true
        }
        
        // Verifica ricorsivamente nelle sottocartelle di parentFolder
        for subfolder in parentFolder.content {
            if isSubfolderOf(targetFolder, in: subfolder) {
                return true
            }
        }
        
        return false
    }
}