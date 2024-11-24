//
//  AutoSavingContentView.swift
//  SwiftDataCascadeBug
//
//  Created by Nikolai Nobadi on 11/23/24.
//

import SwiftUI
import SwiftData

struct AutoSavingContentView: View {
    @Query private var items: [Item]
    @Query private var folders: [Folder]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        FolderListView(title: "Autosaving", folders: folders, itemCount: items.count, addFolder: {
            withAnimation {
                modelContext.insert(Folder(name: "autoSavedFolder"))
            }
        }, addItemToFolder: { folder in
            withAnimation {
                let newItem = Item(timestamp: .now)
                modelContext.insert(newItem)
                newItem.folder = folder
                folder.items.append(newItem)
            }
        }, onDelete: { folderToDelete in
            withAnimation {
                modelContext.delete(folderToDelete)
            }
        })
    }
}


// MARK: - Preview
#Preview {
    AutoSavingContentView()
        .modelContainer(for: Folder.self, inMemory: true)
}
