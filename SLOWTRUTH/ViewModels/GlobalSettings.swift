//
//  GlobalSettings.swift
//  SLOWTRUTH
//
//  Created by Jules on 10/27/23.
//

import Foundation
import Observation
import SwiftOBD2

@MainActor
@Observable
class GlobalSettings {
    var statusMessage = ""
    var showAltText = false
    var connectionType: ConnectionType = .bluetooth {
        didSet {
            UserDefaults.standard.set(connectionType.rawValue, forKey: "connectionType")
        }
    }
    var selectedUnit: MeasurementUnit = .metric {
        didSet {
            UserDefaults.standard.set(selectedUnit.rawValue, forKey: "selectedUnit")
        }
    }

    init() {
        if let unit = UserDefaults.standard.string(forKey: "selectedUnit") {
            selectedUnit = MeasurementUnit(rawValue: unit) ?? .metric
        }
        if let connection = UserDefaults.standard.string(forKey: "connectionType") {
            connectionType = ConnectionType(rawValue: connection) ?? .bluetooth
        }
    }
}
