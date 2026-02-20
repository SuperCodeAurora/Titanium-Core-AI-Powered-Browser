import SwiftUI

// 🎨 THE THEME ENGINE: Controls the visual state of the browser
class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool = true
    @Published var backgroundImage: UIImage? = nil
    
    func toggleTheme() {
        isDarkMode.toggle()
        print("🎨 Theme Engine: Switched to \(isDarkMode ? "Dark" : "Light") Mode")
    }
}
