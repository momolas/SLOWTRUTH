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
    @State var displayType: BottomSheetType = .quarterScreen
    @State var statusMessage: String?
    @State var isDemoMode = false
    @State private var showConnectionSheet = false

    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationView {
                ZStack(alignment: .bottom) {
                    HomeView(displayType: $displayType, isDemoMode: $isDemoMode, statusMessage: $statusMessage)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    showConnectionSheet.toggle()
                                }) {
                                    Image(systemName: "car.circle")
                                }
                            }
                        }

                    if showConnectionSheet {
                        ConnectionStatusView(statusMessage: $statusMessage)
                            .padding()
                            .transition(.move(edge: .bottom))
                    }
                }
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Dashboard", systemImage: "gauge.open.with.lines.needle.33percent")
            }
            .tag(TabBarItem.dashBoard)

            NavigationView {
                LiveDataView(displayType: $displayType,
                    statusMessage: $statusMessage,
                    isDemoMode: $isDemoMode
                )
            }
            .navigationViewStyle(.stack)
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
