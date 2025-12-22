//
//  SettingsView.swift
//  SLOWTRUTH
//
//  Created by kemo konteh on 10/13/23.
//

import SwiftUI
import SwiftOBD2
import Observation

struct SettingsView: View {
    @Environment(GlobalSettings.self) var globalSettings
    @Environment(OBDService.self) var obdService
    @Environment(\.dismiss) var dismiss

    @Binding var isDemoMode: Bool

    var body: some View {
        ZStack {
            BackgroundView(isDemoMode: $isDemoMode)
            VStack {
                List {
                    SettingsConnectionSection()
                        .listRowBackground(Color.clear)

                    SettingsDisplaySection()
                        .listRowBackground(Color.dashboardCard)

                    SettingsOtherSection()
                        .listRowSeparator(.automatic)
                        .listRowBackground(Color.dashboardCard)
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .foregroundStyle(.white)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct SettingsDisplaySection: View {
    @Environment(GlobalSettings.self) var globalSettings

    var body: some View {
        @Bindable var globalSettings = globalSettings
        Section(header: Text("Display").font(.system(size: 20, weight: .bold, design: .rounded))) {
            Picker("Units", selection: $globalSettings.selectedUnit) {
                ForEach(MeasurementUnit.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.menu)
        }
    }
}

struct SettingsConnectionSection: View {
    @Environment(OBDService.self) var obdService

    var body: some View {
        @Bindable var obdService = obdService
        Section(header: Text("Connection").font(.system(size: 20, weight: .bold, design: .rounded))) {
            Picker("Connection Type", selection: $obdService.connectionType) {
                ForEach(ConnectionType.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .background(Color.dashboardCard)

            switch obdService.connectionType {
            case .bluetooth:
                NavigationLink(destination: Text("Bluetooth Settings")) {
                    Text("Bluetooth Settings")
                }
            case .wifi:
                Text("Wifi Settings")

            case .demo:
                Text("Demo Mode")
            }
        }
        .listRowSeparator(.hidden)
    }
}

struct SettingsOtherSection: View {
    var body: some View {
        Section(header: Text("Other").font(.system(size: 20, weight: .bold, design: .rounded))) {
            NavigationLink(destination: AboutView()) {
                Text("About")
            }
        }
    }
}

#Preview {
    SettingsView(isDemoMode: .constant(true))
        .environment(GlobalSettings())
        .environment(OBDService())
}
