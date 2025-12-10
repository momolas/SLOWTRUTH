//
//  DashboardViewModel.swift
//  SLOWTRUTH
//
//  Created by Jules on 10/27/23.
//

import SwiftUI
import SwiftOBD2

@MainActor
@Observable
class DashboardViewModel {
    var fuelLevel: String = "--"
    var batteryVoltage: String = "--"
    var tireStatus: String = "Non dispo"
    var mileage: String = "Non dispo"

    var statusTitle: String = "Tout va bien"
    var statusMessage: String = "Aucun problème détecté."
    var statusColor: Color = .dashboardAccentGreen

    // Status colors
    var fuelColor: Color = .gray
    var batteryColor: Color = .gray

    private var obdService: OBDService?

    func setup(obdService: OBDService) {
        self.obdService = obdService
    }

    func refreshData() async {
        // Use .connectedToVehicle based on ConnectionStatusView.swift
        guard let obdService = obdService, obdService.connectionState == .connectedToVehicle else {
            return
        }

        // TODO: Enable real data fetching when SwiftOBD2 API is confirmed.
        // Currently disabling specific command requests to ensure compilation.
        // Future implementation should use correct API to fetch Fuel Level and Battery Voltage.

        print("DashboardViewModel: Real data fetching is currently disabled pending API verification.")

        // Example logic for status update based on connection
        if obdService.connectionState == .connectedToVehicle {
            // Placeholder: In a real app, we would analyze DTCs here
            statusTitle = "Connecté"
            statusMessage = "Prêt pour le diagnostic."
            statusColor = .dashboardAccentGreen
        }
    }
}
