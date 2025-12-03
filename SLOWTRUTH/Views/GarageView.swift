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

struct VehicleDetailView: View {
    @EnvironmentObject var garage: Garage
    @Environment(\.dismiss) var dismiss
    let vehicle: Vehicle

    var isCurrentVehicle: Bool {
        garage.currentVehicle?.id == vehicle.id
    }

    var body: some View {
        ZStack {
            BackgroundView(isDemoMode: .constant(false))
            ScrollView {
                VStack(spacing: 20) {
                    // Header Card
                    VStack(spacing: 10) {
                        Image(systemName: "car.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                            .shadow(radius: 5)

                        Text("\(vehicle.year) \(vehicle.make) \(vehicle.model)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .padding(.horizontal)

                    // Actions
                    if !isCurrentVehicle {
                        Button(action: {
                            garage.setCurrentVehicle(to: vehicle)
                        }) {
                            Label("Select as Current Vehicle", systemImage: "checkmark.circle")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    } else {
                        Label("Currently Selected", systemImage: "checkmark.circle.fill")
                            .font(.headline)
                            .foregroundColor(.green)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                    }

                    // Details Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Vehicle Details")
                            .font(.headline)
                            .foregroundColor(.gray)

                        DetailRow(title: "VIN", value: vehicle.obdinfo?.vin ?? "Unknown")
                        DetailRow(title: "Protocol", value: vehicle.obdinfo?.obdProtocol?.description ?? "Unknown")
                        DetailRow(title: "ID", value: String(vehicle.id))
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .padding(.horizontal)

                    Spacer()

                    Button(role: .destructive, action: {
                        garage.deleteVehicle(vehicle)
                        dismiss()
                    }) {
                        Label("Delete Vehicle", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                    .padding()
                }
                .padding(.top)
            }
        }
        .navigationTitle(vehicle.model)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white.opacity(0.8))
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding(.vertical, 4)
        Divider()
            .background(Color.gray.opacity(0.5))
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
