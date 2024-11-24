//
//  FolderDetailView.swift
//  SwiftDataCascadeBug
//
//  Created by Nikolai Nobadi on 11/23/24.
//

import SwiftUI

struct FolderDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let addItem: () -> Void
    
    var body: some View {
        Button {
            addItem()
            dismiss()
        } label: {
            Label("Add Item", systemImage: "plus")
        }
    }
}


// MARK: - Preview
#Preview {
    FolderDetailView(addItem: { })
}

