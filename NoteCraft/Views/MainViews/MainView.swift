//
//  MainView.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024
//

import SwiftUI

struct MainView: View {
    // State Variables
    @State private var searchText = ""
    @State private var showingSettings = false
    @State private var showingNewItemOptions = false
    @State private var showingNewFolderSheet = false
    @State private var showingNewNotebookSheet = false
    @State private var newFolderName = ""
    @State private var selectedFolderColor = Color.blue
    
    // Folder Manager
    @StateObject private var folderManager = FolderManager()
    
    // Folder Operations State
    @State private var showingEditFolderSheet = false
    @State private var showingMoveFolderSheet = false
    @State private var showingDeleteConfirmation = false
    @State private var showingShareSheet = false
    @State private var selectedFolder: Folder?
    @State private var editFolderName = ""
    @State private var editFolderColor = Color.blue
    
    // Notebook Navigation State
    @State private var activeNotebook: Notebook? = nil
    
    // Mock User Data
    private let mockUserEmail = "utente@example.com"
    

    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            SidebarView(
                showingSettings: $showingSettings,
                showingNewItemOptions: $showingNewItemOptions,
                folderManager: folderManager,
                mockUserEmail: mockUserEmail
            )
            
        } detail: {
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
                                
                                // Quaderni esistenti
                                ForEach(folderManager.currentNotebooks) { notebook in
                                    NotebookCardView(notebook: notebook)
                                        .onTapGesture {
                                            activeNotebook = notebook
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
                        ToolbarItem(placement: .navigationBarTrailing) {
                            MainContentToolbar(
                                searchText: $searchText,
                                showingNewItemOptions: $showingNewItemOptions
                            )
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
            NewItemOptionsView(
                folderManager: folderManager,
                showingNewFolderSheet: $showingNewFolderSheet,
                showingNewNotebookSheet: $showingNewNotebookSheet
            )
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
        .sheet(isPresented: $showingNewNotebookSheet) {
            NewNotebookCreationView(folderManager: folderManager)
                .presentationDetents([.medium, .large])
        }
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
                Text("Sei sicuro di voler eliminare la cartella '\(folder.name)'? Questa azione non può essere annullata.")
            }
        }
        .fullScreenCover(item: $activeNotebook) { notebook in
            NotebookView(notebook: notebook)
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