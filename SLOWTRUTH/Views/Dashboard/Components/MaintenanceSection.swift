//
//  MaintenanceSection.swift
//  SLOWTRUTH
//
//  Created by Jules on 10/27/23.
//

import SwiftUI

struct MaintenanceSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Maintenance recommandée")
                .font(.headline)
                .foregroundStyle(.white)

            VStack(spacing: 10) {
                MaintenanceRow(title: "Filtre à air", subtitle: "Remplacer dans 2,500 km", icon: "air.purifier", iconColor: .blue)
                MaintenanceRow(title: "Vérification des freins", subtitle: "Contrôle au prochain service", icon: "car.side.fill", iconColor: .blue)
            }
        }
    }
}

struct MaintenanceRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(iconColor)
                .frame(width: 40, height: 40)
                .background(iconColor.opacity(0.2), in: .rect(cornerRadius: 10))

            VStack(alignment: .leading) {
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }

            Spacer()

            Button("Agir") {
                // Action
            }
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.1), in: .rect(cornerRadius: 8))
            .foregroundStyle(.white)
        }
        .padding()
        .background(Color.dashboardCard, in: .rect(cornerRadius: 15))
    }
}

#Preview {
    MaintenanceSection()
        .padding()
        .background(Color.dashboardBackground)
}
