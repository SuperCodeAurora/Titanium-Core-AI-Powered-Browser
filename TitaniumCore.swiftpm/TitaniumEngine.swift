import SwiftUI
import WebKit

// 🛡️ TITANIUM ENGINE CORE
struct TitaniumWebView: UIViewRepresentable {
    @Binding var url: URL

    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = preferences
        
        // 1. Engine Initialization
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.customUserAgent = "TitaniumCore/2.0 (iPad; Armored Engine)"
        
        // 🛡️ 2. THE TITANIUM SHIELD (Hardware-Level Ad & Tracker Blocker)
        // This JSON defines exactly what to kill before it hits the iPad's memory.
        let blockRules = """
        [
            {
                "trigger": { "url-filter": ".*(google-analytics|doubleclick|adsystem|adsense|facebook\\\\.com/tr).*" },
                "action": { "type": "block" }
            },
            {
                "trigger": { "url-filter": ".*" },
                "action": {
                    "type": "css-display-none",
                    "selector": ".ad, .ads, .advert, .banner, .popup, [class*='ad-'], [id*='ad-'], .sponsored"
                }
            }
        ]
        """
        
        // 3. Compile the armor and inject it into the Engine
        WKContentRuleListStore.default().compileContentRuleList(
            forIdentifier: "TitaniumShield",
            encodedContentRuleList: blockRules.data(using: .utf8)
        ) { ruleList, error in
            if let error = error {
                print("❌ Shield Malfunction: \(error.localizedDescription)")
                return
            }
            if let armor = ruleList {
                webView.configuration.userContentController.add(armor)
                print("🛡️ Titanium Shield: Online and armed. Trackers will be terminated.")
            }
        }
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != url && !uiView.isLoading {
            uiView.load(URLRequest(url: url))
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: TitaniumWebView

        init(_ parent: TitaniumWebView) {
            self.parent = parent
