//
//  VehicleStatusCard.swift
//  SLOWTRUTH
//
//  Created by Jules on 10/27/23.
//

import SwiftUI

struct VehicleStatusCard: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "car.fill")
                .font(.system(size: 60))
                .foregroundStyle(Color.dashboardAccentGreen)

            VStack(spacing: 5) {
                Text("Tout va bien")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text("Aucun problème détecté.")
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
