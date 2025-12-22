//
//  DashboardViewModel.swift
//  SLOWTRUTH
//
//  Created by Jules on 10/27/23.
//

import SwiftUI
import Combine
import SwiftOBD2
import Observation

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

    func refreshData() {
        guard let obdService = obdService, obdService.connectionState == .connectedToVehicle else {
            return
        }

        statusTitle = "Connecté"
        statusMessage = "Prêt pour le diagnostic."
        statusColor = .dashboardAccentGreen

        Task {
            // Request Fuel Level and Control Module Voltage
            await obdService.addPID(.mode1(.fuelLevel))
            await obdService.addPID(.mode1(.controlModuleVoltage))

            for await measurements in obdService.startContinuousUpdates() {
                if let fuel = measurements[.mode1(.fuelLevel)]?.value {
                    self.fuelLevel = String(format: "%.0f%%", fuel)
                    self.fuelColor = .green
                }

                if let voltage = measurements[.mode1(.controlModuleVoltage)]?.value {
                    self.batteryVoltage = String(format: "%.1f V", voltage)
                    self.batteryColor = .green
                }
            }
        }
    }
}
