//
//  SwiftBrowserApp.swift
//  SwiftBrowser
//		
//  Created by Denis Yazan on 21.03.2025.
//

import SwiftUI
import SwiftData

@main
struct SwiftBrowserApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800, idealWidth: 1800, maxWidth: .infinity,
                        minHeight: 600, idealHeight: 2000, maxHeight: .infinity)
            
        }.windowStyle(HiddenTitleBarWindowStyle())
    }
}
