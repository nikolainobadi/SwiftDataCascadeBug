//
//  NavButtonViewModifier.swift
//  SwiftDataCascadeBug
//
//  Created by Nikolai Nobadi on 11/23/24.
//

import SwiftUI

struct NavButtonViewModifier: ViewModifier {
    let isActive: Bool
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                if isActive {
                    ToolbarItem {
                        Button(action: action) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
    }
}

extension View {
    func withNavButton(isActive: Bool, action: @escaping () -> Void) -> some View {
        modifier(NavButtonViewModifier(isActive: isActive, action: action))
    }
}

