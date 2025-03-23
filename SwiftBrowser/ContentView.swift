//
//  ContentView.swift
//  SwiftBrowser
//
//  Created by Denis Yazan on 21.03.2025.
//

import SwiftUI
import SwiftData
import WebKit

struct ContentView: View {
    
    @State private var webView: WKWebView?
    @State private var canGoBack: Bool = false
    @State private var canGoForward: Bool = false
    @State private var isLoading: Bool = false
    @State private var urlString: String = "https://www.duckduckgo.com"
    @State private var currentURL: URL = URL(string: "https://www.duckduckgo.com")!
    
    var body: some View {
        VStack{
            HStack {
                
                Button {
                    webView?.goBack()
                    updateCurrentURL()
                } label: { Image(systemName: "arrowshape.backward.fill") }.disabled(!canGoBack)
                
                Button {
                    webView?.goForward()
                    updateCurrentURL()
                } label: { Image(systemName: "arrowshape.forward.fill") }.disabled(!canGoForward)
                
                Button {
                    if isLoading {
                        webView?.stopLoading()
                    } else {
                        webView?.reload()
                    }
                } label: { Image(systemName: "arrow.clockwise.circle") }
                
                TextField("Enter URL", text: $urlString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        loadURL()
                    }
                
                Button { loadURL() } label: { Image(systemName: "magnifyingglass") }
            }.padding(3)
            
            WebView(url: currentURL,
                    webView: $webView,
                    canGoBack: $canGoBack,
                    canGoForward: $canGoForward,
                    isLoading: $isLoading,
                    urlDidChange: {
                        newURL in
                        if let url = newURL {
                            urlString = url.absoluteString
                            currentURL = url
                        }
                    }
            )
        }
    }
    
    private func updateCurrentURL() {
        if let url = webView?.url{
            currentURL = url
            urlString = url.absoluteString
        }
    }
    
    private func loadURL() {
        var validUrlString = urlString
        if !validUrlString.hasPrefix("http://") && !validUrlString.hasPrefix("https://") {
            validUrlString = "https://" + validUrlString //TODO make proper logic of calculating connection type
        }
        if let url = URL(string: validUrlString) {
            currentURL = url
            urlString = validUrlString
            webView?.load(URLRequest(url: currentURL))
        }
    }
}

#Preview {
    ContentView()
}
