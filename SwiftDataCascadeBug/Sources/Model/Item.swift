//
//  Item.swift
//  SwiftDataCascadeBug
//
//  Created by Nikolai Nobadi on 11/23/24.
//

import SwiftData
import Foundation

@Model
final class Item {
    var folder: Folder?
    var timestamp: Date
    var isManuallySaved: Bool
    
    init(timestamp: Date, isManuallySaved: Bool) {
        self.timestamp = timestamp
        self.isManuallySaved = isManuallySaved
    }
}
