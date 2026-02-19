import SwiftUI
import WebKit

// 🛡️ TITANIUM ENGINE CORE
// This is not a basic viewer. This is a delegate-driven WebKit engine.
struct TitaniumWebView: UIViewRepresentable {
    @Binding var url: URL

    func makeUIView(context: Context) -> WKWebView {
        // 1. Advanced Configuration
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = preferences
        
        // 2. The "Manus" AI Bridge (Injecting our own code into the website)
        let agentScript = """
        console.log('Titanium Core: DOM fully parsed. AI Agent standing by.');
        // Future AI DOM-reading logic will go here.
        """
        let script = WKUserScript(source: agentScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)

        // 3. Engine Initialization
        let webView = WKWebView(frame: .zero, configuration: config)
        
        // 4. Pro Features
        webView.navigationDelegate = context.coordinator // Links to our custom Brain
        webView.allowsBackForwardNavigationGestures = true // "Mammoth" Swipe Gestures
        webView.customUserAgent = "TitaniumCore/1.0 (iPad; AI-Native Engine)" // We are our own platform now
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        // Prevent infinite reload loops (A common beginner mistake)
        if uiView.url != url && !uiView.isLoading {
            uiView.load(request)
        }
    }

    // MARK: - The Brain (Coordinator)
    // This allows Swift to "listen" to the website's events (loading, clicking, errors).
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: TitaniumWebView

        init(_ parent: TitaniumWebView) {
            self.parent = parent
        }

        // Event: When the page starts loading
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("⚙️ Titanium Engine: Engaging Hyperdrive for \(webView.url?.absoluteString ?? "Unknown URL")")
        }

        // Event: When the page finishes loading
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("✅ Titanium Engine: Page locked. Ready for user interaction.")
        }
        
        // Event: If the website crashes or fails
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("❌ Titanium Engine Error: \(error.localizedDescription)")
        }
    }
}
