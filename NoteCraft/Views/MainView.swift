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
}

struct MainView: View {
    // MARK: - State Variables
    @State private var showingSidebar = false
    @State private var showingSettings = false
    @State private var showingNewItemOptions = false
    @State private var showingNewFolderSheet = false
    @State private var newFolderName = ""
    @State private var selectedFolderColor = Color.blue
    @State private var searchText = ""
    @StateObject private var folderManager = FolderManager()
    
    // MARK: - Mock User Data
    private let mockUserEmail = "utente@example.com"
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Vista principale
                NavigationView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Breadcrumbs
                        if !folderManager.currentPath.isEmpty {
                            BreadcrumbsView(folderManager: folderManager)
                                .padding(.horizontal)
                                .padding(.top, 8)
                        }
                        
                        // Contenuto principale
                        ScrollView {
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(minimum: 220, maximum: 220), spacing: 30),
                                    GridItem(.flexible(minimum: 220, maximum: 220), spacing: 30),
                                    GridItem(.flexible(minimum: 220, maximum: 220), spacing: 30),
                                    GridItem(.flexible(minimum: 220, maximum: 220), spacing: 30)
                                ],
                                alignment: .leading,
                                spacing: 30
                            ) {
                                // Cartelle esistenti
                                ForEach(folderManager.currentFolders) { folder in
                                    FolderCardView(folder: folder)
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
                    .navigationBarTitleDisplayMode(.large)
                    .searchable(text: $searchText, prompt: "Cerca quaderni e cartelle")
                    .toolbar {
                        // Avatar utente e email a sinistra
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showingSidebar = true
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "person.crop.circle")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                    
                                    Text(mockUserEmail)
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                }
                            }
                        }
                        
                        // Pulsante Nuovo Elemento a destra
                        ToolbarItem(placement: .navigationBarTrailing) {
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
                
                // Barra laterale
                if showingSidebar {
                    SidebarView(
                        isPresented: $showingSidebar,
                        showingSettings: $showingSettings,
                        sidebarWidth: geometry.size.width / 5
                    )
                }
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
                     .frame(width: 220, height: 280)
                 
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
    
    var body: some View {
        VStack(spacing: 10) {
            // Contenitore principale della cartella con sfondo
            ZStack {
                // Sfondo con colore della cartella
                RoundedRectangle(cornerRadius: 10)
                    .fill(folder.color.opacity(0.1))
                    .stroke(folder.color.opacity(0.3), lineWidth: 2)
                    .frame(width: 220, height: 280)
                
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
            }
            
            // Numero di elementi
            Text("\(folder.content.count) elementi")
                .font(.body)
                .foregroundColor(.secondary)
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
