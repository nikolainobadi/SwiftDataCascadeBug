import SwiftUI

@main
struct SwiftDataCascadeBugApp: App {
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                AutoSavingContentView()
                    .modelContainer(for: Folder.self)
                    .tabItem {
                        Label("Auto Save", systemImage: "tray.full")
                    }
                
                ManualSavingContentView()
                    .modelContainer(for: Folder.self, isAutosaveEnabled: false)
                    .tabItem {
                        Label("Manual Save", systemImage: "tray.and.arrow.down")
                    }
            }
        }
    }
}
