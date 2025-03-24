//
//  WebView.swift
//  SwiftBrowser
//
//  Created by Denis Yazan on 23.03.2025.
//
import SwiftUI
import WebKit

struct WebViewWrapper: View {
    @ObservedObject var tab: BrowserTab
    let isActive: Bool
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    @Binding var isLoading: Bool
    let urlDidChange: (URL?) -> Void
    
    var body: some View {
        Group {
            if let webView = tab.webView {
                WebView(
                    url: tab.url ?? URL(string: "https://www.duckduckgo.com")!,
                    webView: Binding.constant(webView),
                    canGoBack: $canGoBack,
                    canGoForward: $canGoForward,
                    isLoading: $isLoading,
                    urlDidChange: urlDidChange
                )
            }
        }
    }
}

struct WebView: NSViewRepresentable {
    let url: URL
    @Binding var webView: WKWebView?
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    @Binding var isLoading: Bool
    let urlDidChange: (URL?) -> Void
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        DispatchQueue.main.async {
            self.webView = webView
        }
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        DispatchQueue.main.async {
            canGoBack = nsView.canGoBack
            canGoForward = nsView.canGoForward
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        init(_ parent: WebView) {
            self.parent = parent
        }
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.urlDidChange(webView.url)
        }
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
    }
}
