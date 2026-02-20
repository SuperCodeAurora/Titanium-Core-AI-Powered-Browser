import SwiftUI
import Combine

// 1. The Blueprint (Now 'Codable' so it can be written to the SSD)
struct TitaniumTab: Identifiable, Equatable, Codable {
    var id = UUID() 
    var url: URL
    var title: String = "New Tab"
    var isLoading: Bool = false
    var progress: Double = 0.0
}

// 2. The Brain (Now with Permanent Memory)
class TabManager: ObservableObject {
    
    // didSet means: Every single time a tab is added or removed, instantly save to the hard drive!
    @Published var tabs: [TitaniumTab] = [] {
        didSet { saveTabsToDisk() }
    }
    
    @Published var activeTabId: UUID? {
        didSet { saveActiveTabToDisk() }
    }
    
    init() {
        // The moment the app launches, try to recover the memory
        recoverMemory()
    }
    
    // MARK: - 💾 MEMORY SYSTEM (The Cure for Amnesia)
    
    private func saveTabsToDisk() {
        if let encodedData = try? JSONEncoder().encode(tabs) {
            UserDefaults.standard.set(encodedData, forKey: "titanium_saved_tabs")
        }
    }
    
    private func saveActiveTabToDisk() {
        if let id = activeTabId {
            UserDefaults.standard.set(id.uuidString, forKey: "titanium_active_tab")
        }
    }
    
    private func recoverMemory() {
        // Step 1: Search the iPad's hard drive for saved tabs
        if let savedData = UserDefaults.standard.data(forKey: "titanium_saved_tabs"),
           let decodedTabs = try? JSONDecoder().decode([TitaniumTab].self, from: savedData),
           !decodedTabs.isEmpty {
            
            self.tabs = decodedTabs
            
            // Step 2: Try to remember exactly which tab they were looking at
            if let savedIdString = UserDefaults.standard.string(forKey: "titanium_active_tab"),
               let savedId = UUID(uuidString: savedIdString) {
                self.activeTabId = savedId
            } else {
                self.activeTabId = decodedTabs.first?.id
            }
            print("🧠 Memory Restored: Successfully loaded \(tabs.count) tabs from SSD.")
            
        } else {
            // First time opening the app, or all tabs were closed
            print("🧠 Blank Slate: Booting default tab.")
            createNewTab(url: "https://www.apple.com")
        }
    }
    
    // MARK: - Core Operations
    
    func createNewTab(url stringURL: String) {
        guard let validURL = URL(string: stringURL) else { return }
        let newTab = TitaniumTab(url: validURL)
        
        tabs.append(newTab)
        activeTabId = newTab.id
        print("🧠 Spawned new tab [\(newTab.id)]")
    }
    
    func closeTab(id: UUID) {
        tabs.removeAll { $0.id == id }
        if activeTabId == id {
            activeTabId = tabs.last?.id
        }
        print("🧠 Terminated tab [\(id)]")
    }
    
    var activeURL: URL? {
        tabs.first(where: { $0.id == activeTabId })?.url
    }
}
