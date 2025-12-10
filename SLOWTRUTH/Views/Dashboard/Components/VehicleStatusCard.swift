//
//  VehicleStatusCard.swift
//  SLOWTRUTH
//
//  Created by Jules on 10/27/23.
//

import SwiftUI

struct VehicleStatusCard: View {
    var title: String = "Tout va bien"
    var message: String = "Aucun problème détecté."
    var iconColor: Color = .dashboardAccentGreen

    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "car.fill")
                .font(.system(size: 60))
                .foregroundStyle(iconColor)

            VStack(spacing: 5) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(30)
        .background(Color.dashboardCard, in: .rect(cornerRadius: 20))
    }
}

#Preview {
    VehicleStatusCard()
        .padding()
        .background(Color.dashboardBackground)
}
