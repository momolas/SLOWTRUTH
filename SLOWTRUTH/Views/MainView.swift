//
//  TabView.swift
//  SmartOBD2
//
//  Created by kemo konteh on 8/5/23.
//

import SwiftUI
import SwiftOBD2

struct MainView: View {
    @State private var tabSelection: TabBarItem = .dashBoard
    @State var statusMessage: String?
    @State var isDemoMode = false

    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationStack {
                HomeView(isDemoMode: $isDemoMode, statusMessage: $statusMessage)
                    .toolbar(.hidden, for: .navigationBar)
            }
            .tabItem {
                Label(TabBarItem.dashBoard.title, systemImage: TabBarItem.dashBoard.iconName)
            }
            .tag(TabBarItem.dashBoard)

            NavigationStack {
                VehicleDiagnosticsView(isDemoMode: $isDemoMode)
            }
            .tabItem {
                Label(TabBarItem.diagnostic.title, systemImage: TabBarItem.diagnostic.iconName)
            }
            .tag(TabBarItem.diagnostic)

            NavigationStack {
                LogsView(isDemoMode: $isDemoMode)
            }
            .tabItem {
                Label(TabBarItem.history.title, systemImage: TabBarItem.history.iconName)
            }
            .tag(TabBarItem.history)

            NavigationStack {
                SettingsView(isDemoMode: $isDemoMode)
            }
            .tabItem {
                Label(TabBarItem.settings.title, systemImage: TabBarItem.settings.iconName)
            }
            .tag(TabBarItem.settings)
        }
        .tint(Color.blue)
    }
}

#Preview {
    MainView()
        .environment(GlobalSettings())
        .environmentObject(Garage())
        .environmentObject(OBDService())
}
