//
//  VehicleDiagnosticsView.swift
//  SLOWTRUTH
//
//  Created by kemo konteh on 9/30/23.
//

import SwiftUI
import SwiftOBD2

struct VehicleDiagnosticsView: View {
    @Environment(Garage.self) var garage
    @Environment(OBDService.self) var obd2Service

    @Binding var isDemoMode: Bool

    @State private var progress: Double = 0.0
    @State private var requestingTroubleCodes = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    // Feedback
    let notificationFeedback = UINotificationFeedbackGenerator()
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        ZStack {
            Color.dashboardBackground.ignoresSafeArea()

            VStack {
                ScrollView {
                    VStack(spacing: 30) {
                        DiagnosticProgressView(progress: progress)
                            .padding(.top, 40)

                        VStack(alignment: .leading, spacing: 20) {
                            Text("Résultats")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)

                            if let currentVehicle = garage.currentVehicle {
                                if let codes = currentVehicle.troubleCodes, !codes.isEmpty {
                                    ForEach(Array(codes.keys), id: \.self) { ecuid in
                                        let ecuCodes = codes[ecuid] ?? []
                                        if ecuCodes.isEmpty {
                                            DiagnosticResultRow(systemName: "Système moteur", status: "Aucun problème détecté", isError: false)
                                        } else {
                                            ForEach(ecuCodes, id: \.code) { code in
                                                DiagnosticResultRow(systemName: "Système moteur", status: "Code \(code.code)", isError: true)
                                            }
                                        }
                                    }
                                } else {
                                    if requestingTroubleCodes {
                                        DiagnosticResultRow(systemName: "Système moteur", status: "Analyse en cours...", isError: false)
                                    } else if progress >= 1.0 {
                                        DiagnosticResultRow(systemName: "Système moteur", status: "Aucun problème détecté", isError: false)
                                    } else {
                                        DiagnosticResultRow(systemName: "Système moteur", status: "En attente de diagnostic", isError: false)
                                    }
                                }

                                if isDemoMode && progress >= 1.0 {
                                    DiagnosticResultRow(systemName: "Système de freinage", status: "Code P0571", isError: true)
                                }
                            } else {
                                Text("Aucun véhicule sélectionné")
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    .padding()
                }

                Spacer()

                Button(action: toggleScan) {
                    Text(requestingTroubleCodes ? "Arrêter le diagnostic" : "Lancer le diagnostic")
                        .font(.headline)
                        .foregroundStyle(requestingTroubleCodes ? .red : .white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.dashboardCard, in: .rect(cornerRadius: 15))
                }
                .padding()
                .padding(.bottom, 20)
            }
        }
        .navigationTitle("Diagnostic en temps réel")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Erreur", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    func toggleScan() {
        if requestingTroubleCodes {
            requestingTroubleCodes = false
            // Logic to cancel task would require holding a task handle, simplified here.
        } else {
            startScan()
        }
    }

    func startScan() {
        guard garage.currentVehicle != nil else {
            alertMessage = "Veuillez sélectionner un véhicule dans le garage."
            showAlert = true
            return
        }

        requestingTroubleCodes = true
        progress = 0.0
        impactFeedback.impactOccurred()

        Task {
            do {
                // 1. Init
                updateProgress(0.1)

                if isDemoMode {
                    for p in stride(from: 0.1, to: 1.0, by: 0.1) {
                        try await Task.sleep(for: .seconds(0.3))
                        if !requestingTroubleCodes { return }
                        updateProgress(p)
                    }
                    updateProgress(1.0)
                    requestingTroubleCodes = false
                    notificationFeedback.notificationOccurred(.success)
                    return
                }

                // 2. Real Scan
                updateProgress(0.2)
                // Assuming getStatus is synchronous based on error history
				_ = try await obd2Service.getStatus()
                updateProgress(0.4)

                // Check status
                // ...

                updateProgress(0.6)
                // Assuming scanForTroubleCodes is synchronous
				let codes = try await obd2Service.scanForTroubleCodes()
                updateProgress(0.9)

                if var vehicle = garage.currentVehicle {
                    vehicle.troubleCodes = codes
                    garage.updateVehicle(vehicle)
                }

                updateProgress(1.0)
                requestingTroubleCodes = false
                notificationFeedback.notificationOccurred(.success)

            } catch {
                if isDemoMode { return }
                alertMessage = error.localizedDescription
                showAlert = true
                requestingTroubleCodes = false
                progress = 0.0
                notificationFeedback.notificationOccurred(.error)
            }
        }
    }

    @MainActor
    func updateProgress(_ value: Double) {
        withAnimation {
            progress = value
        }
    }
}

#Preview {
    NavigationStack {
        VehicleDiagnosticsView(isDemoMode: .constant(true))
            .environment(Garage())
            .environment(OBDService())
    }
}
