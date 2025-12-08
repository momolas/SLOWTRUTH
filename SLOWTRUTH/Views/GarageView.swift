//
//  GarageView.swift
//  SLOWTRUTH
//
//  Created by kemo konteh on 10/2/23.
//

import SwiftUI
import SwiftOBD2

struct GarageView: View {
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
                        EmptyGarageView(isAddingVehicle: $isAddingVehicle)
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
}

#Preview {
    NavigationStack {
        GarageView(isDemoMode: .constant(false))
        .background(LinearGradient(.darkStart, .darkEnd))
        .environment(GlobalSettings())
        .environmentObject(Garage())
    }
}
