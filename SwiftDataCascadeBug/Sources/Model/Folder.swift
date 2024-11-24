//
//  Folder.swift
//  SwiftDataCascadeBug
//
//  Created by Nikolai Nobadi on 11/23/24.
//

import SwiftData

@Model
final class Folder {
    @Attribute(.unique) var name: String
    @Relationship(deleteRule: .cascade) var items: [Item] = []
    
    var isManuallySaved: Bool
    
    init(name: String, isManuallySaved: Bool) {
        self.name = name
        self.isManuallySaved = isManuallySaved
    }
}
