//
//  ContentView.swift
//  SwiftDataCascadeBug
//
//  Created by Nikolai Nobadi on 11/23/24.
//

import SwiftUI
import SwiftData

/// `ContentView` displays the folders and items stored in the database. It provides actions for adding, deleting, and interacting with folders and their associated items.
///
/// - Important: When autosave is disabled (`isManuallySaved == true`), calling `saveContextIfNecessary` is the **only way** to persist changes to the database.
struct ContentView: View {
    @Query private var items: [Item]
    @Query private var folders: [Folder]
    @State private var selectedFolder: Folder?
    @Environment(\.modelContext) private var modelContext
    
    let title: String
    let isManuallySaved: Bool
    
    /// Initializes the view with the save mode configuration.
    /// - Parameter isManuallySaved: Indicates whether autosave is disabled for this instance.
    init(isManuallySaved: Bool) {
        self.title = "\(isManuallySaved ? "Manual" : "Auto") Save"
        self.isManuallySaved = isManuallySaved
        // Filter `Item` and `Folder` queries based on the save mode
        self._items = .init(filter: #Predicate<Item> { $0.isManuallySaved == isManuallySaved })
        self._folders = .init(filter: #Predicate<Folder> { $0.isManuallySaved == isManuallySaved })
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Database Info") {
                    Text("Folder count: \(folders.count)")
                    Text("Item count: \(items.count)")
                    
                    // Button to delete items with no associated folder
                    if !items.isEmpty && folders.isEmpty {
                        Button("Delete orphaned items") {
                            deleteOrphanedItems()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                Section("Folders") {
                    ForEach(folders) { folder in
                        HStack {
                            Text(folder.name)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedFolder = folder
                        }
                        .swipeActions {
                            Button {
                                deleteFolder(folder)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                // Add Folder button if no folders exist
                if folders.isEmpty {
                    ToolbarItem {
                        Button(action: addFolder) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            // Navigate to folder details and provide the option to add items
            .navigationDestination(item: $selectedFolder) { folder in
                Button {
                    addItemToFolder(folder)
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }
}

// MARK: - Private Methods
private extension ContentView {
    /// Adds a new folder to the database.
    /// - Note: Persists changes only if `isManuallySaved == true` via `saveContextIfNecessary`.
    func addFolder() {
        withAnimation {
            modelContext.insert(Folder(name: "\(title)Folder", isManuallySaved: isManuallySaved))
            saveContextIfNecessary()
        }
    }
    
    /// Adds a new item to the selected folder.
    /// - Parameter folder: The folder to associate the new item with.
    /// - Note: Persists changes only if `isManuallySaved == true` via `saveContextIfNecessary`.
    func addItemToFolder(_ folder: Folder) {
        withAnimation {
            let newItem = Item(timestamp: .now, isManuallySaved: isManuallySaved)
            
            modelContext.insert(newItem)
            newItem.folder = folder
            folder.items.append(newItem)
            saveContextIfNecessary()
            selectedFolder = nil
        }
    }
    
    /// Deletes the specified folder from the database.
    /// - Parameter folder: The folder to delete.
    /// - Note: Persists changes only if `isManuallySaved == true` via `saveContextIfNecessary`.
    func deleteFolder(_ folder: Folder) {
        withAnimation {
            modelContext.delete(folder)
            saveContextIfNecessary()
        }
    }
    
    /// Deletes all orphaned items (items with no associated folder).
    /// - Note: Persists changes only if `isManuallySaved == true` via `saveContextIfNecessary`.
    func deleteOrphanedItems() {
        withAnimation {
            for item in items where item.folder == nil {
                modelContext.delete(item)
            }
            saveContextIfNecessary()
        }
    }
    
    /// Persists any unsaved changes in the `modelContext` when `isManuallySaved == true`.
    ///
    /// - Important: This is the **only way** to persist data when autosave is disabled.
    func saveContextIfNecessary() {
        if isManuallySaved {
            try? modelContext.save()
        }
    }
}
