//
//  ContentView.swift
//  SwiftBrowser
//
//  Created by Denis Yazan on 21.03.2025.
//

import SwiftUI
import SwiftData
import WebKit

struct WebView: NSViewRepresentable {
    let url: URL
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.load(URLRequest(url: url))
    }
}

struct ContentView: View {
    
    @State private var urlString: String = "https://www.google.com"
    @State private var currentURL: URL = URL(string: "https://www.google.com")!
    
    var body: some View {
        VStack{
            TextField("Enter URL", text: $urlString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    loadURL()
                }
            
            WebView(url: currentURL)
        }
    }
    
    private func loadURL() {
        var validUrlString = urlString
        if !validUrlString.hasPrefix("http://") && !validUrlString.hasPrefix("https://") {
            validUrlString = "http://" + validUrlString
        }
        if let url = URL(string: validUrlString) {
            currentURL = url
            urlString = validUrlString
        }
    }
}

#Preview {
    ContentView()
}
