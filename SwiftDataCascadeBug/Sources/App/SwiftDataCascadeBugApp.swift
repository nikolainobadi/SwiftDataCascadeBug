import SwiftUI

@main
struct SwiftDataCascadeBugApp: App {
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView(isManuallySaved: false)
                    .modelContainer(for: Folder.self)
                    .tabItem {
                        Label("Auto Save", systemImage: "tray.full")
                    }
                
                ContentView(isManuallySaved: true)
                    .modelContainer(for: Folder.self, isAutosaveEnabled: false)
                    .tabItem {
                        Label("Manual Save", systemImage: "tray.and.arrow.down")
                    }
            }
        }
    }
}
