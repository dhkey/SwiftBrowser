//
//  TabView.swift
//  SwiftBrowser
//
//  Created by Denis Yazan on 24.03.2025.
//
import SwiftUI
import WebKit

class BrowserTab: Identifiable, ObservableObject {
    let id: UUID = UUID()
    var url: URL?
    var title: String?
    
    var webView: WKWebView?
    
    var isLoading: Binding<Bool>?
    var isSelected: Binding<Bool>?
    var canGoBack: Binding<Bool>?
    var canGoForward: Binding<Bool>?

    init(url: URL? = nil, title: String? = nil,
         isLoading: Binding<Bool>? = nil,
         isSelected: Binding<Bool>? = nil,
         canGoBack: Binding<Bool>? = nil,
         canGoForward: Binding<Bool>? = nil) {
        
        self.url = url
        self.title = title
        self.isLoading = isLoading
        self.isSelected = isSelected
        self.canGoBack = canGoBack
        self.canGoForward = canGoForward
        self.webView = WKWebView()
    }
    
    func reload() { webView?.reload() }
    func stopLoading() { webView?.stopLoading() }
    func goBack() { webView?.goBack() }
    func goForward() { webView?.goForward() }
    
    func loadURL(url: URL) {
        self.url = url
        webView?.load(URLRequest(url: url))
    }
}

class TabManager: ObservableObject {
    @Published var tabs: [BrowserTab] = []
    @Published var activeTab: BrowserTab?
    
    init() {
        activeTab = tabs.first
    }

    var activeWebView: WKWebView? {
        activeTab?.webView
    }
    
    func addNewTab(url: URL? = nil) {
        let newTab = BrowserTab(url: url)
        tabs.append(newTab)
        activeTab = newTab
        if url == nil {
            newTab.loadURL(url: URL(string: "https://www.duckduckgo.com")!)
        }
    }
    
    func closeTab(tab: BrowserTab) {
            guard let index = tabs.firstIndex(where: { $0.id == tab.id }) else { return }
            tab.webView?.removeFromSuperview()
            tab.webView = nil
            tabs.remove(at: index)
            if tab.id == activeTab?.id {
                if !tabs.isEmpty {
                    activeTab = tabs.last
                } else {
                    addNewTab()
                }
            }
        }
    
    func switchToTab(tab: BrowserTab) {
        activeTab = tab
    }
}

struct TabItemView: View {
    @ObservedObject var tab: BrowserTab
    let isActive: Bool
    let tabManager: TabManager
    
    var body: some View {
        HStack {
            Text(tab.title ?? "Untitled")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor((tab.isSelected?.wrappedValue ?? false) ? .black : .white)
                .padding(.horizontal, 30)
            
            Image(systemName: "xmark")
                .font(.system(size: 10, weight: .bold))
                .padding(5)
                .onTapGesture {
                    tabManager.closeTab(tab: tab)
                }
        }
        .padding(0)
        .background(isActive ? Color.black : Color.gray.opacity(0.2))
        .onTapGesture {
            tabManager.switchToTab(tab: tab)
        }
    }
}
