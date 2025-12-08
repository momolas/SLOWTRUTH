//
//  HomeView.swift
//  SLOWTRUTH
//
//  Created by kemo konteh on 9/30/23.
//

import SwiftUI
import SwiftOBD2

struct HomeView: View {
    @EnvironmentObject var obdService: OBDService
    @Environment(\.colorScheme) var colorScheme

    @Binding var isDemoMode: Bool
    @Binding var statusMessage: String?
    @State private var showConnectionSheet = false

    @State private var dashboardVM = DashboardViewModel()
    @State private var showConnectionSheet = false

    var body: some View {
        ZStack {
            BackgroundView(isDemoMode: $isDemoMode)

            VStack(spacing: 0) {
                DashboardHeaderView {
                    showConnectionSheet.toggle()
                }

                ScrollView {
                    VStack(spacing: 20) {
                        NavigationLink(destination: GarageView(isDemoMode: $isDemoMode)) {
                            VehicleStatusCard()
                        }
                        .buttonStyle(.plain)

                        MetricsGrid(
                            fuelLevel: isDemoMode ? "80%" : dashboardVM.fuelLevel,
                            batteryVoltage: isDemoMode ? "12.4 V" : dashboardVM.batteryVoltage
                        )

                        AlertsSection()
                        MaintenanceSection()
                        LastDiagnosticCard()
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showConnectionSheet) {
            ConnectionStatusView(statusMessage: $statusMessage)
                .presentationDetents([.fraction(0.4), .medium])
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            dashboardVM.setup(obdService: obdService)
        }
        .task {
            if !isDemoMode {
                await dashboardVM.refreshData()
            }
        }
        .onChange(of: obdService.connectionState) { _, newState in
            if newState == .connected && !isDemoMode {
                Task {
                    await dashboardVM.refreshData()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(isDemoMode: .constant(true), statusMessage: .constant(nil))
            .environmentObject(OBDService())
            .environmentObject(Garage())
    }
}
