import SwiftUI
import SwiftData
import WebKit

struct ContentView: View {
    @State private var canGoBack: Bool = false
    @State private var canGoForward: Bool = false
    @State private var isLoading: Bool = false
    @State private var urlString: String = "www.duckduckgo.com"
    @StateObject private var tabManager = TabManager()
    
    var body: some View {
        VStack {
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(tabManager.tabs, id: \.id) { tab in
                            TabItemView(tab: tab,
                            isActive: tabManager.activeTab?.id == tab.id,
                            tabManager: tabManager)
                        }
                    }
                }.frame(height: 20)
            }.padding(EdgeInsets(top: 5, leading: 70, bottom: 0, trailing: 10))
            HStack {
                Button {
                    tabManager.activeTab?.goBack()
                    updateCurrentURL()
                } label: { Image(systemName: "arrowshape.backward.fill") }.disabled(!canGoBack)
                
                Button {
                    tabManager.activeTab?.goForward()
                    updateCurrentURL()
                } label: { Image(systemName: "arrowshape.forward.fill") }.disabled(!canGoForward)
                
                Button {
                    if isLoading {
                        tabManager.activeTab?.stopLoading()
                    } else {
                        tabManager.activeTab?.reload()
                    }
                } label: {
                    isLoading ? Image(systemName: "xmark.circle") : Image(systemName: "arrow.clockwise.circle")
                }
                
                TextField("Enter URL", text: $urlString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        loadURL()
                    }
                
                Button {
                    tabManager.addNewTab()
                } label: { Image(systemName: "magnifyingglass")
            }
        
        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        ZStack {
            ForEach(tabManager.tabs) { tab in
                WebViewWrapper(tab: tab,
                               isActive: tabManager.activeTab?.id == tab.id,
                               canGoBack: $canGoBack,
                               canGoForward: $canGoForward,
                               isLoading: $isLoading,
                               urlDidChange: { newURL in
                    tab.url = newURL
                    if let url = newURL {
                        urlString = url.absoluteString
                    }
                })
                .opacity(tabManager.activeTab?.id == tab.id ? 1 : 0)
            }
        }
    }
    .onAppear {
        if tabManager.tabs.isEmpty {
            tabManager.addNewTab()
        }
    }.ignoresSafeArea(.all)
}
    
    private func updateCurrentURL() {
        if let url = tabManager.activeTab?.url {
            urlString = url.absoluteString
        }
    }
    
    private func loadURL() {
        var validUrlString = urlString
        if !validUrlString.hasPrefix("http://") && !validUrlString.hasPrefix("https://") {
            validUrlString = "https://" + validUrlString
        }
        
        if let url = URL(string: validUrlString) {
            urlString = validUrlString
            if let existingTab = tabManager.activeTab {
                existingTab.loadURL(url: url)
            } else {
                tabManager.addNewTab(url: url)
            }
        }
    }
}

#Preview {
    ContentView()
}
