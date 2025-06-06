//
//  MainView.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024
//

import SwiftUI

// MARK: - Folder Model
struct Folder: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var color: Color
    var content: [Folder] = []
    
    static func == (lhs: Folder, rhs: Folder) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Folder Manager
class FolderManager: ObservableObject {
    @Published var rootFolders: [Folder] = []
    @Published var currentPath: [Folder] = []
    
    var currentFolders: [Folder] {
        if currentPath.isEmpty {
            return rootFolders
        } else {
            return currentPath.last?.content ?? []
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

struct MainView: View {
    // MARK: - State Variables
    @State private var showingSettings = false
    @State private var showingNewItemOptions = false
    @State private var showingNewFolderSheet = false
    @State private var newFolderName = ""
    @State private var selectedFolderColor = Color.blue
    @State private var searchText = ""
    @StateObject private var folderManager = FolderManager()
    
    // MARK: - Folder Operations State
    @State private var showingEditFolderSheet = false
    @State private var showingMoveFolderSheet = false
    @State private var showingDeleteConfirmation = false
    @State private var showingShareSheet = false
    @State private var selectedFolder: Folder?
    @State private var editFolderName = ""
    @State private var editFolderColor = Color.blue
    
    // MARK: - Mock User Data
    private let mockUserEmail = "utente@example.com"
    
    // MARK: - Responsive Grid Columns
    private func adaptiveColumns(for geometry: GeometryProxy) -> [GridItem] {
        let availableWidth = geometry.size.width - 40 // Padding orizzontale
        let cardWidth: CGFloat = 198 // Ridotto del 10% da 220
        let spacing: CGFloat = 30
        
        // Calcola il numero di colonne che possono entrare
        let columnsCount = max(1, Int((availableWidth + spacing) / (cardWidth + spacing)))
        
        return Array(repeating: GridItem(.flexible(minimum: cardWidth, maximum: cardWidth), spacing: spacing), count: columnsCount)
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            // MARK: - Sidebar Content
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
                        .foregroundColor(.primary)
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
            
        } detail: {
            // MARK: - Main Content
            GeometryReader { geometry in
                NavigationView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Breadcrumbs
                        if !folderManager.currentPath.isEmpty {
                            BreadcrumbsView(folderManager: folderManager)
                                .padding(.horizontal)
                                .padding(.top, 8)
                                .padding(.bottom, 10)
                        }
                        
                        // Contenuto principale con griglia responsive
                        ScrollView {
                            LazyVGrid(
                                columns: adaptiveColumns(for: geometry),
                                alignment: .leading,
                                spacing: 30
                            ) {
                                // Cartelle esistenti
                                ForEach(folderManager.currentFolders) { folder in
                                    FolderCardView(
                                        folder: folder,
                                        selectedFolder: $selectedFolder,
                                        showingEditFolderSheet: $showingEditFolderSheet,
                                        showingMoveFolderSheet: $showingMoveFolderSheet,
                                        showingDeleteConfirmation: $showingDeleteConfirmation,
                                        showingShareSheet: $showingShareSheet
                                    )
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            folderManager.navigateToFolder(folder)
                                        }
                                    }
                                }
                                
                                // Card "Crea Nuovo" - sempre ultima a destra
                                BookCardView()
                                    .onTapGesture {
                                        showingNewItemOptions = true
                                    }
                            }
                            .padding(.horizontal, 20)
                        }
                        .contentMargins(.top, 0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .navigationTitle("NoteCraft")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        // Gruppo di elementi allineati a destra
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            // Barra di ricerca
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16))
                                
                                TextField("Cerca quaderni e cartelle", text: $searchText)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .font(.system(size: 16))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(.systemGray6))
                            )
                            .frame(width: 250)
                            
                            // Pulsante Nuovo Elemento
                            Button(action: {
                                showingNewItemOptions = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showingNewItemOptions) {
            NewItemOptionsView(folderManager: folderManager, showingNewFolderSheet: $showingNewFolderSheet)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showingNewFolderSheet) {
            NewFolderCreationView(
                folderManager: folderManager,
                newFolderName: $newFolderName,
                selectedFolderColor: $selectedFolderColor
            )
            .presentationDetents([.medium])
        }
        // MARK: - Folder Operations Sheets
        .sheet(isPresented: $showingEditFolderSheet) {
            if let folder = selectedFolder {
                EditFolderView(
                    folder: folder,
                    folderManager: folderManager,
                    editFolderName: $editFolderName,
                    editFolderColor: $editFolderColor
                )
                .onAppear {
                    editFolderName = folder.name
                    editFolderColor = folder.color
                }
            }
        }
        .sheet(isPresented: $showingMoveFolderSheet) {
            if let folder = selectedFolder {
                MoveFolderView(
                    folder: folder,
                    folderManager: folderManager
                )
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            if let folder = selectedFolder {
                ShareFolderView(folder: folder)
            }
        }
        .alert("Elimina Cartella", isPresented: $showingDeleteConfirmation) {
            Button("Elimina", role: .destructive) {
                if let folder = selectedFolder {
                    folderManager.deleteFolder(folder)
                    selectedFolder = nil
                }
            }
            Button("Annulla", role: .cancel) {
                selectedFolder = nil
            }
        } message: {
            if let folder = selectedFolder {
                Text("Sei sicuro di voler eliminare la cartella '\(folder.name)' e tutto il suo contenuto? Questa azione non può essere annullata.")
            }
        }
    }
    
}



// MARK: - BookCardView Component (Card "Crea Nuovo")
struct BookCardView: View {
    var body: some View {
        VStack(spacing: 10) {
            // Contenitore principale con sfondo azzurrino
            ZStack {
                // Sfondo azzurrino con contorno
                 RoundedRectangle(cornerRadius: 10)
                     .fill(Color.blue.opacity(0.1))
                     .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                     .frame(width: 198, height: 252)
                 
                 VStack(spacing: 12) {
                     // Simbolo "+" centrato
                     Image(systemName: "plus")
                         .font(.system(size: 60, weight: .light))
                         .foregroundColor(.blue)
                     
                     // Testo "Crea Nuovo"
                     Text("Crea Nuovo")
                         .font(.title3)
                         .fontWeight(.semibold)
                         .foregroundColor(.blue)
                         .multilineTextAlignment(.center)
                 }
            }
            
            // Testo descrittivo
            Text("Aggiungi elemento")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

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
        VStack(spacing: 10) {
            // Contenitore principale della cartella con sfondo
            ZStack {
                // Sfondo con colore della cartella
                RoundedRectangle(cornerRadius: 10)
                    .fill(folder.color.opacity(0.1))
                    .stroke(folder.color.opacity(0.3), lineWidth: 2)
                    .frame(width: 198, height: 252)
                
                VStack(spacing: 16) {
                    // Icona cartella
                    Image(systemName: "folder.fill")
                        .font(.system(size: 80))
                        .foregroundColor(folder.color)
                    
                    // Nome cartella
                    Text(folder.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(folder.color)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 12)
                }
                
                // Menu tre puntini nell'angolo superiore destro
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            showingContextMenu = true
                        }) {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.gray)
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.9))
                                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                                )
                        }
                        .padding(.top, 8)
                        .padding(.trailing, 8)
                    }
                    Spacer()
                }
            }
            
            // Numero di elementi
            Text("\(folder.content.count) elementi")
                .font(.body)
                .foregroundColor(.secondary)
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

// MARK: - SidebarView Component
struct SidebarView: View {
    @Binding var isPresented: Bool
    @Binding var showingSettings: Bool
    let sidebarWidth: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            // Contenuto della barra laterale
            VStack {
                // Area superiore - Integrazioni AI Future
                VStack(alignment: .leading, spacing: 16) {
                    Text("Integrazioni AI Future")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.top, 20)
                    
                    Text("Funzionalità AI avanzate saranno disponibili qui")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                // Area inferiore - Pulsanti
                VStack(spacing: 12) {
                    // Pulsante Impostazioni
                    Button(action: {
                        showingSettings = true
                        isPresented = false
                    }) {
                        HStack {
                            Image(systemName: "gearshape")
                                .font(.title3)
                            Text("Impostazioni")
                                .font(.body)
                            Spacer()
                        }
                        .foregroundColor(.primary)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.1))
                        )
                    }
                    
                    // Pulsante Log Out
                    Button(action: {
                        // TODO: Implementare logout
                        print("Log out tapped")
                        isPresented = false
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
            .frame(width: sidebarWidth)
            .background(
                Color(UIColor.systemBackground)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 0)
            )
            .transition(.move(edge: .leading))
            
            // Area trasparente per chiudere la sidebar
            Color.black.opacity(0.3)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isPresented = false
                    }
                }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - NewItemOptionsView Component
struct NewItemOptionsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var folderManager: FolderManager
    @Binding var showingNewFolderSheet: Bool
    
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
        default:
            // TODO: Implementare altre azioni
            print("\(optionName) tapped")
            dismiss()
        }
    }
}



// MARK: - NewFolderCreationView Component
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

// MARK: - Edit Folder View
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

// MARK: - Move Folder View
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

// MARK: - Share Folder View
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

// MARK: - Settings View (Temporanea)
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Impostazioni dell'App")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Questa è una vista temporanea per le impostazioni.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 40)
            .navigationTitle("Impostazioni")
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
}

// MARK: - Preview
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
