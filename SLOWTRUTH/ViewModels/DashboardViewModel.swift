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
        // The following code is commented out because 'startScan' and 'OBDCommand'
        // usage matched a different version of the library and caused compilation errors.

        /*
        // Fetch Fuel Level
        do {
             let fuel = try await obdService.startScan(commands: [.fuelLevel])
             if let fuelMeas = fuel.first(where: { $0.command == .fuelLevel }) {
                 self.fuelLevel = String(format: "%.0f%%", fuelMeas.value)
                 self.fuelColor = fuelMeas.value < 20 ? .red : .dashboardAccentGreen
             }
        } catch {
            print("Error fetching fuel: \(error)")
        }

        // Fetch Battery Voltage
        do {
            let voltage = try await obdService.startScan(commands: [.controlModuleVoltage])
            if let voltMeas = voltage.first(where: { $0.command == .controlModuleVoltage }) {
                self.batteryVoltage = String(format: "%.1f V", voltMeas.value)
                self.batteryColor = voltMeas.value < 12.0 ? .red : .dashboardAccentGreen
            }
        } catch {
            print("Error fetching voltage: \(error)")
        }
        */

        print("DashboardViewModel: Real data fetching is currently disabled pending API verification.")
    }
}
