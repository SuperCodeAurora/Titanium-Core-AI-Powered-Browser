import SwiftUI
import Combine

// 1. The Blueprint of a single Tab
struct TitaniumTab: Identifiable, Equatable {
    let id = UUID() // Gives every tab a unique cryptographic ID
    var url: URL
    var title: String = "New Tab"
    var isLoading: Bool = false
    var progress: Double = 0.0
}

// 2. The Brain (State Object)
// By making this an ObservableObject, the UI will instantly redraw whenever a tab changes.
class TabManager: ObservableObject {
    
    // @Published broadcasts changes to the entire app instantly
    @Published var tabs: [TitaniumTab] = []
    @Published var activeTabId: UUID?
    
    init() {
        // Start the browser with a default tab
        createNewTab(url: "https://www.apple.com")
    }
    
    // MARK: - Core Operations
    
    func createNewTab(url stringURL: String) {
        guard let validURL = URL(string: stringURL) else { return }
        let newTab = TitaniumTab(url: validURL)
        
        tabs.append(newTab)
        activeTabId = newTab.id // Automatically switch to the new tab
        
        print("🧠 Titanium Brain: Spawned new tab [\(newTab.id)]")
    }
    
    func closeTab(id: UUID) {
        tabs.removeAll { $0.id == id }
        
        // If we close the active tab, switch to the last available one
        if activeTabId == id {
            activeTabId = tabs.last?.id
        }
        print("🧠 Titanium Brain: Terminated tab [\(id)]")
    }
    
    // A helper to get the URL of whatever tab the user is currently looking at
    var activeURL: URL? {
        tabs.first(where: { $0.id == activeTabId })?.url
    }
}
