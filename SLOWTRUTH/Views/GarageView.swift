//
//  GarageView.swift
//  SLOWTRUTH
//
//  Created by kemo konteh on 10/2/23.
//

import SwiftUI
import SwiftOBD2

struct GarageView: View {
    @EnvironmentObject var globalSettings: GlobalSettings
    @EnvironmentObject var garage: Garage

    @Environment(\.dismiss) var dismiss
    @Binding var isDemoMode: Bool

    @State private var isAddingVehicle = false

    var body: some View {
        ZStack {
            BackgroundView(isDemoMode: $isDemoMode)
            ScrollView {
                LazyVStack(spacing: 15) {
                    if garage.garageVehicles.isEmpty {
                        emptyState
                    } else {
                        ForEach(garage.garageVehicles, id: \.self) { vehicle in
                            NavigationLink(destination: VehicleDetailView(vehicle: vehicle)) {
                                VehicleCard(vehicle: vehicle, isSelected: garage.currentVehicle?.id == vehicle.id)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Garage")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isAddingVehicle = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                }
            }
        }
        .sheet(isPresented: $isAddingVehicle) {
            AddVehicleView(isPresented: $isAddingVehicle)
        }
    }

    var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "car.2.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
                .padding(.top, 50)

            Text("No Vehicles in Garage")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text("Add your vehicle to start monitoring its health.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Add Vehicle") {
                isAddingVehicle = true
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct VehicleCard: View {
    let vehicle: Vehicle
    let isSelected: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(vehicle.make)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))

                Text(vehicle.model)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text(vehicle.year)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.green)
            } else {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
                )
        )
        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
    }
}

#Preview {
    NavigationStack {
        GarageView(isDemoMode: .constant(false))
        .background(LinearGradient(.darkStart, .darkEnd))
        .environmentObject(GlobalSettings())
        .environmentObject(Garage())
    }
}
