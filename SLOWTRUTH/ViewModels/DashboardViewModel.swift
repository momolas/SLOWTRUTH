//
//  DashboardViewModel.swift
//  SLOWTRUTH
//
//  Created by Jules on 10/27/23.
//

import SwiftUI
import Combine
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

    private var cancellables = Set<AnyCancellable>()

    func refreshData() {
        guard let obdService = obdService, obdService.connectionState == .connectedToVehicle else {
            return
        }

        cancellables.removeAll()

        obdService.startContinuousUpdates([.mode1(.fuelLevel), .mode1(.controlModuleVoltage)])
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching data: \(error)")
                }
            }, receiveValue: { [weak self] measurements in
                guard let self = self else { return }

                if let fuelMeas = measurements[.mode1(.fuelLevel)] {
                    self.fuelLevel = fuelMeas.value.formatted(.number.precision(.fractionLength(0))) + "%"
                    self.fuelColor = fuelMeas.value < 20 ? .red : .dashboardAccentGreen
                }

                if let voltMeas = measurements[.mode1(.controlModuleVoltage)] {
                    self.batteryVoltage = voltMeas.value.formatted(.number.precision(.fractionLength(1))) + " V"
                    self.batteryColor = voltMeas.value < 12.0 ? .red : .dashboardAccentGreen
                }
            })
            .store(in: &cancellables)
    }
}
