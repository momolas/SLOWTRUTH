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
        @Bindable var globalSettings = globalSettings
        return ZStack {
            BackgroundView(isDemoMode: $isDemoMode)
            VStack {
                List {
                    connectionSection
                        .listRowBackground(Color.clear)

                    displaySection
                        .listRowBackground(Color.dashboardCard)

                    otherSection
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

    var displaySection: some View {
        @Bindable var globalSettings = globalSettings
        return Section(header: Text("Display").font(.system(size: 20, weight: .bold, design: .rounded))) {
            Picker("Units", selection: $globalSettings.selectedUnit) {
                ForEach(MeasurementUnit.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.menu)
        }
    }

    var connectionSection: some View {
        @Bindable var obdService = obdService
        return Section(header: Text("Connection").font(.system(size: 20, weight: .bold, design: .rounded))) {
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

    var otherSection: some View {
        Section(header: Text("Other").font(.system(size: 20, weight: .bold, design: .rounded))) {
            NavigationLink(destination: AboutView()) {
                Text("About")
            }
        }
    }

}

struct ProtocolPicker: View {
    @Binding var selectedProtocol: PROTOCOL

    var body: some View {
        HStack {
            Text("OBD Protocol: ")

            Picker("Select Protocol", selection: $selectedProtocol) {
                ForEach(PROTOCOL.asArray, id: \.self) { protocolItem in
                    Text(protocolItem.description).tag(protocolItem)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct RoundedRectangleStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.endColor())
            )
    }
}

#Preview {
    SettingsView(isDemoMode: .constant(true))
        .environment(GlobalSettings())
        .environment(OBDService())
}
