//
//  VehicleCard.swift
//  SLOWTRUTH
//
//  Created by Jules on 10/27/23.
//

import SwiftUI
import SwiftOBD2

struct VehicleCard: View {
    let vehicle: Vehicle
    let isSelected: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(vehicle.make)
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.8))

                Text(vehicle.model)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text(vehicle.year)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.green)
            } else {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
    }
}
