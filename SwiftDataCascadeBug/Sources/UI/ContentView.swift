//
//  ContentView.swift
//  SwiftDataCascadeBug
//
//  Created by Nikolai Nobadi on 11/23/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var items: [Item]
    @Query private var folders: [Folder]
    @State private var selectedFolder: Folder?
    @Environment(\.modelContext) private var modelContext
    
    let title: String
    let isManuallySaved: Bool
    
    init(isManuallySaved: Bool) {
        self.title = "\(isManuallySaved ? "Manual" : "Auto") Save"
        self.isManuallySaved = isManuallySaved
        self._items = .init(filter: #Predicate<Item> { $0.isManuallySaved == isManuallySaved })
        self._folders = .init(filter: #Predicate<Folder> { $0.isManuallySaved == isManuallySaved })
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Databasae Info") {
                    Text("Folder count: \(folders.count)")
                    Text("Item count: \(items.count)")
                    
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
                if folders.isEmpty {
                    ToolbarItem {
                        Button(action: addFolder) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
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
    func addFolder() {
        withAnimation {
            let newFolder = Folder(name: "\(title)Folder", isManuallySaved: isManuallySaved)
            modelContext.insert(newFolder)
            if isManuallySaved {
                try? modelContext.save()
            }
        }
    }
    
    func addItemToFolder(_ folder: Folder) {
        withAnimation {
            let newItem = Item(timestamp: .now, isManuallySaved: isManuallySaved)
            modelContext.insert(newItem)
            newItem.folder = folder
            folder.items.append(newItem)
            if isManuallySaved {
                try? modelContext.save()
            }
            selectedFolder = nil
        }
    }
    
    func deleteFolder(_ folder: Folder) {
        withAnimation {
            modelContext.delete(folder)
            if isManuallySaved {
                try? modelContext.save()
            }
        }
    }
    
    func deleteOrphanedItems() {
        withAnimation {
            for item in items where item.folder == nil {
                modelContext.delete(item)
            }
            if isManuallySaved {
                try? modelContext.save()
            }
        }
    }
}
