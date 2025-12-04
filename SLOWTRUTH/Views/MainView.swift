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
    @State private var showConnectionSheet = false

    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationStack {
                HomeView(isDemoMode: $isDemoMode, statusMessage: $statusMessage)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                showConnectionSheet.toggle()
                            }) {
                                Image(systemName: "car.circle")
                            }
                        }
                    }
                    .sheet(isPresented: $showConnectionSheet) {
                        ConnectionStatusView(statusMessage: $statusMessage)
                            .presentationDetents([.fraction(0.4), .medium])
                            .presentationDragIndicator(.visible)
                    }
            }
            .tabItem {
                Label("Dashboard", systemImage: "gauge.open.with.lines.needle.33percent")
            }
            .tag(TabBarItem.dashBoard)

            NavigationStack {
                LiveDataView(statusMessage: $statusMessage,
                    isDemoMode: $isDemoMode
                )
            }
            .tabItem {
                Label("Features", systemImage: "person")
            }
            .tag(TabBarItem.features)
        }
    }
}

#Preview {
    MainView()
        .environmentObject(GlobalSettings())
        .environmentObject(Garage())
        .environmentObject(OBDService())
}
