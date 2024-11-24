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
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
