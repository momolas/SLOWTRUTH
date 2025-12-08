//
//  AlertsSection.swift
//  SLOWTRUTH
//
//  Created by Jules on 10/27/23.
//

import SwiftUI

struct AlertsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Alertes importantes")
                .font(.headline)
                .foregroundStyle(.white)

            VStack(spacing: 10) {
                AlertRow(title: "Changement d'huile", subtitle: "Dans 500 km", icon: "oil.can.fill", iconColor: .yellow)
                AlertRow(title: "Pression pneu AVD", subtitle: "Vérification requise", icon: "exclamationmark.triangle.fill", iconColor: .red)
            }
        }
    }
}

struct AlertRow: View {
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

            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
        }
        .padding()
        .background(Color.dashboardCard, in: .rect(cornerRadius: 15))
    }
}

#Preview {
    AlertsSection()
        .padding()
        .background(Color.dashboardBackground)
}
