//
//  HomeView.swift
//  SLOWTRUTH
//
//  Created by kemo konteh on 9/30/23.
//

import SwiftUI
import SwiftOBD2

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isDemoMode: Bool
    @Binding var statusMessage: String?

    var body: some View {
        ZStack {
            BackgroundView(isDemoMode: $isDemoMode)
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        SectionView(title: "Diagnostics",
                                    subtitle: "Read Vehicle Health",
                                    iconName: "wrench.and.screwdriver",
                                    destination: VehicleDiagnosticsView(isDemoMode: $isDemoMode)
                        )

                        SectionView(title: "Logs",
                                    subtitle: "View Logs",
                                    iconName: "flowchart",
                                    destination: LogsView())
                    }
                    .padding(20)
                    .padding(.bottom, 20)

                    Divider().background(Color.white).padding(.horizontal, 10)
                    NavigationLink(destination: GarageView(isDemoMode: $isDemoMode)) {
                        SettingsAboutSectionView(title: "Garage", iconName: "car.circle", iconColor: .blue.opacity(0.6))
                    }

                    NavigationLink {
                        SettingsView(isDemoMode: $isDemoMode)
                    } label: {
                        SettingsAboutSectionView(title: "Settings", iconName: "gear", iconColor: .green.opacity(0.6))
                    }

                    NavigationLink {
                        TestingScreen()
                    } label: {
                        SettingsAboutSectionView(title: "Testing Hub", iconName: "gear", iconColor: .green.opacity(0.6))
                    }
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                HStack {
                    Text("Powered by SLOWTRUTH")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(5)
                }
            }
        }
    }
}

struct SettingsAboutSectionView: View {
    let title: String
    let iconName: String
    let iconColor: Color

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(iconColor)

            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)

        }
        .frame(maxWidth: .infinity, maxHeight: 400, alignment: .leading)
        .padding(.horizontal, 22)
    }
}

#Preview {
    NavigationStack {
        HomeView(isDemoMode: .constant(true), statusMessage: .constant(nil))
    }
}
