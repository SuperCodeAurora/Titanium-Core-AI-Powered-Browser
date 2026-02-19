import SwiftUI

@main
struct TitaniumCoreApp: App {
    var body: some Scene {
        WindowGroup {
            // This tells the app to load the "Shell" (ContentView) we designed earlier.
            ContentView() 
                .preferredColorScheme(.dark) // Forces the app into "Dark Mode" for that sleek Titanium vibe.
        }
    }
}
