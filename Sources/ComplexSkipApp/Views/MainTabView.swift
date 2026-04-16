//
//  MainTabView.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//

#if !os(Android)

// Views/MainTabView.swift
import SwiftUI
import SkipFuse
import SkipFuseUI
public struct MainTabView: View {
    @Environment(RentalViewModel.self) private var viewMode
    @State public var selectedTab = 0
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "safari")
                }
                .tag(0)
            
            MapExplorerView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(1)
            
            MyRentalsView()
                .tabItem {
                    Label("Rentals", systemImage: "key")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(3)
        }
        .tint(.luxuryGold)
    }
}
#endif
