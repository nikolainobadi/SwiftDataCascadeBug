//
//  FolderListView.swift
//  SwiftDataCascadeBug
//
//  Created by Nikolai Nobadi on 11/23/24.
//

import SwiftUI

struct FolderListView: View {
    let title: String
    let folders: [Folder]
    let itemCount: Int
    let addFolder: () -> Void
    let addItemToFolder: (Folder) -> Void
    let onDelete: (Folder) -> Void
    
    var body: some View {
        NavigationStack {
            List {
                Section("Database Info") {
                    Text("Folder count: \(folders.count)")
                    Text("Item count: \(itemCount)")
                }
                
                Section("Folders") {
                    ForEach(folders) { folder in
                        NavigationLink(folder.name, value: folder)
                            .swipeActions {
                                Button {
                                    onDelete(folder)
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .navigationTitle(title)
            .withNavButton(isActive: folders.isEmpty, action: addFolder)
            .navigationDestination(for: Folder.self) { folder in
                FolderDetailView {
                    addItemToFolder(folder)
                }
            }
        }
    }
}


// MARK: - Preview
#Preview {
    FolderListView(title: "title", folders: [], itemCount: 0, addFolder: { }, addItemToFolder: { _ in }, onDelete: { _ in })
}

