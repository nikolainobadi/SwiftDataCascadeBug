import SwiftUI

@main
struct SwiftDataCascadeBugApp: App {
    init() {
        // Print the location of the database directory for debugging purposes.
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ForEach(SaveMode.allCases, id: \.self) { mode in
                    ContentView(isManuallySaved: !mode.isAutosaveEnabled)
                        .modelContainer(for: Folder.self, isAutosaveEnabled: mode.isAutosaveEnabled)
                        .tabItem {
                            mode.tabLabel
                        }
                }
            }
        }
    }
}


// MARK: - Dependencies
enum SaveMode: CaseIterable {
    case auto, manual
    
    var isAutosaveEnabled: Bool {
        return self == .auto
    }
    
    var tabLabel: Label<Text, Image> {
        switch self {
        case .auto:
            return Label("Auto Save", systemImage: "tray.full")
        case .manual:
            return Label("Manual Save", systemImage: "tray.and.arrow.down")
        }
    }
}
