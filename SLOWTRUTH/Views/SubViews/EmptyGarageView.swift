//
//  EmptyGarageView.swift
//  SLOWTRUTH
//
//  Created by Jules on 10/27/23.
//

import SwiftUI

struct EmptyGarageView: View {
    @Binding var isAddingVehicle: Bool

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "car.2.fill")
                .font(.system(size: 60))
                .foregroundStyle(.gray)
                .padding(.top, 50)

            Text("No Vehicles in Garage")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)

            Text("Add your vehicle to start monitoring its health.")
                .font(.body)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Add Vehicle") {
                isAddingVehicle = true
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
