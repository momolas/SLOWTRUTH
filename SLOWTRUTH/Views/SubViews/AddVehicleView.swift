//
//  AddVehicleView.swift
//  SLOWTRUTH
//
//  Created by kemo konteh on 10/10/23.
//

import SwiftUI
import SwiftOBD2
import Observation

struct Manufacturer: Codable, Hashable {
    let make: String
    let models: [Model]
}

struct Model: Codable, Hashable {
    let name: String
    let years: [String]
}

@MainActor
@Observable
class AddVehicleViewModel {
    var carData: [Manufacturer]?
    var showError = false

    init() {
        do {
            try fetchData()
            showError = false
        } catch {
            showError = true
        }
    }

    func fetchData() throws {
        guard let url = Bundle.main.url(forResource: "Cars", withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }
        let data = try Data(contentsOf: url)
        self.carData = try JSONDecoder().decode([Manufacturer].self, from: data)
    }
}

struct AddVehicleView: View {
    @Binding var isPresented: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(isDemoMode: .constant(false))
                VStack {
                    List {
                        NavigationLink(destination: AutoAddVehicleView(isPresented: $isPresented)) {
                            Text("Auto-detect Vehicle")
                                .foregroundStyle(.white)
                        }
                        .listRowBackground(Color.dashboardCard)

                        NavigationLink(destination: ManuallyAddVehicleView(isPresented: $isPresented)) {
                            Text( "Manually Add Vehicle")
                                .foregroundStyle(.white)
                        }
                        .listRowBackground(Color.dashboardCard)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Add Vehicle")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AutoAddVehicleView: View {
    @Environment(Garage.self) var garage
    @Environment(OBDService.self) var obdService
    @Binding var isPresented: Bool
    @State var statusMessage: String = ""
    @State var isLoading: Bool = false

    let notificationFeedback = UINotificationFeedbackGenerator()
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        ZStack(alignment: .center) {
            BackgroundView(isDemoMode: .constant(false))
            VStack(alignment: .center, spacing: 10) {
                Text("Before you start")
                    .font(.title)
                    .foregroundStyle(.white)
                Text("Plug in the scanner to the OBD port\nTurn on your vehicles engine\nMake sure that Bluetooth is on")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)

                DetectButton(statusMessage: $statusMessage, isLoading: $isLoading) {
                    impactFeedback.prepare()
                    impactFeedback.impactOccurred()
                    detectVehicle()
                }
            }
            .padding(30)
            .background(Color.dashboardCard, in: .rect(cornerRadius: 20))
            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
            .padding(.bottom, 40)
        }
    }

    func detectVehicle() {
        isLoading = true
        notificationFeedback.prepare()

        Task { @MainActor in
            do {
                guard let vinInfo = try await connect() else {
                    statusMessage = "Vehicle Not Detected"
                    isLoading = false
                    return
                }
                statusMessage = "Found Vehicle"
                notificationFeedback.notificationOccurred(.success)

                try? await Task.sleep(for: .seconds(1))
                statusMessage = "Make: \(vinInfo.Make)\nModel: \(vinInfo.Model)\nYear: \(vinInfo.ModelYear)"

                try? await Task.sleep(for: .seconds(3))
                isLoading = false
                isPresented = false
            } catch {
                statusMessage = "Error: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }

    func connect() async throws -> VINInfo? {
        let obdInfo = try await obdService.startConnection()

        guard let vin = obdInfo.vin else {
            return nil
        }

        guard let vinInfo = try await getVINInfo(vin: vin).Results.first else {
            return nil
        }

        return vinInfo
    }
}

struct DetectButton: View {
    @Binding var statusMessage: String
    @Binding var isLoading: Bool
    let action: () -> Void

    var body: some View {
        VStack {
            Text(statusMessage)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color.dashboardAccentGreen)
                .padding(.bottom)

            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2.0, anchor: .center)
            } else {
                Button(action: action) {
                    Text("Detect Vehicle")
                        .padding(10)
                        .foregroundStyle(.white)
                }
                .buttonStyle(.bordered)
                .tint(Color.dashboardCard)
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
            }
        }
        .frame(maxHeight: 200)
    }
}

struct ManuallyAddVehicleView: View {
    @State var viewModel = AddVehicleViewModel()
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            BackgroundView(isDemoMode: .constant(false))
            if let carData = viewModel.carData {
                List {
                    ForEach(carData.sorted(by: { $0.make < $1.make }), id: \.self) { manufacturer in
                        NavigationLink(
                            destination: ModelView(isPresented: $isPresented,
                                                   manufacturer: manufacturer),
                            label: {
                                Text(manufacturer.make)
                                    .foregroundStyle(.white)
                            })
                    }
                    .listRowBackground(Color.dashboardCard)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.inset)
            } else {
                ProgressView()
            }
        }
        .navigationTitle("Select Make")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ModelView: View {
    @State var selectedModel: Model?
    @Binding var isPresented: Bool

    let manufacturer: Manufacturer

    var body: some View {
        ZStack {
            BackgroundView(isDemoMode: .constant(false))
            List {
                ForEach(manufacturer.models.sorted(by: { $0.name < $1.name }), id: \.self) { carModel in
                    NavigationLink(
                        destination: YearView(isPresented: $isPresented,
                                              carModel: carModel,
                                              manufacturer: manufacturer),
                        label: {
                            Text(carModel.name)
                                .foregroundStyle(.white)
                        })
                }
                .listRowBackground(Color.dashboardCard)
            }
            .scrollContentBackground(.hidden)
            .listStyle(.inset)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct YearView: View {
    @Binding var isPresented: Bool

    let carModel: Model
    let manufacturer: Manufacturer

    var body: some View {
        ZStack {
            BackgroundView(isDemoMode: .constant(false))
            List {
                ForEach(carModel.years.sorted(by: { $0 > $1 }), id: \.self) { year in
                    NavigationLink(
                        destination: ConfirmView(isPresented: $isPresented,
                                                 carModel: carModel,
                                                 manufacturer: manufacturer,
                                                 year: year),
                        label: {
                            Text("\(year)")
                                .font(.headline)
                                .foregroundStyle(.white)
                        })
                }
                .listRowBackground(Color.dashboardCard)
            }
            .scrollContentBackground(.hidden)
            .listStyle(.inset)
        }
        .navigationBarTitle(manufacturer.make + " " + carModel.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ConfirmView: View {
    @Environment(Garage.self) var garage
    @Binding var isPresented: Bool

    let carModel: Model
    let manufacturer: Manufacturer
    let year: String

    var body: some View {
        ZStack {
            BackgroundView(isDemoMode: .constant(false))
            VStack {
                Text("\(year) \(manufacturer.make) \(carModel.name)")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding()
                Button {
                    garage.addVehicle(
                        make: manufacturer.make,
                        model: carModel.name,
                        year: year
                    )
                    isPresented = false

                } label: {
                    VStack {
                        Text("Add Vehicle")
                            .foregroundStyle(.white)
                    }
                    .frame(width: 200, height: 50)
                    .background(Color.dashboardCard, in: .rect(cornerRadius: 15))
                }
            }
        }
    }
}

#Preview {
    AddVehicleView(isPresented: .constant(true))
            .environment(GlobalSettings())
            .environment(Garage())
            .environment(OBDService())

}

struct VINResponse: Codable {
    let Results: [VINInfo]
}

struct VINInfo: Codable {
    let Make: String
    let Model: String
    let ModelYear: String
}

func getVINInfo(vin: String) async throws -> VINResponse {
    let urlString = "https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVinValues/\(vin)?format=json"
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(VINResponse.self, from: data)
}
