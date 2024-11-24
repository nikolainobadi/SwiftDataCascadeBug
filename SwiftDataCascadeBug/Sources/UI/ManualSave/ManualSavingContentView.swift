//
//  ManualSavingContentView.swift
//  SwiftDataCascadeBug
//
//  Created by Nikolai Nobadi on 11/23/24.
//

import SwiftUI
import SwiftData

struct ManualSavingContentView: View {
    @Query private var items: [Item]
    @Query private var folders: [Folder]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        FolderListView(title: "Manually Saving", folders: folders, itemCount: items.count, addFolder: {
            withAnimation {
                modelContext.insert(Folder(name: "manuallySavedFolder"))
                try? modelContext.save()
            }
        }, addItemToFolder: { folder in
            withAnimation {
                let newItem = Item(timestamp: .now)
                modelContext.insert(newItem)
                newItem.folder = folder
                folder.items.append(newItem)
                try? modelContext.save()
            }
        }, onDelete: { folderToDelete in
            withAnimation {
                modelContext.delete(folderToDelete)
                try? modelContext.save()
            }
        })
    }
}


// MARK: - Preview
#Preview {
    ManualSavingContentView()
        .modelContainer(for: Folder.self, inMemory: true, isAutosaveEnabled: false)
}
