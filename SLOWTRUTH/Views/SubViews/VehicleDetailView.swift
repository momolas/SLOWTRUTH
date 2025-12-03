//
//  VehicleDetailView.swift
//  SLOWTRUTH
//
//  Created by Jules on 10/27/23.
//

import SwiftUI
import SwiftOBD2

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
