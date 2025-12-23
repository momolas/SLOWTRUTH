//
//  ConnectionStatusView.swift
//  SLOWTRUTH
//
//  Created by Jules on 10/27/23.
//

import SwiftUI
import SwiftOBD2
import Observation

struct ConnectionStatusView: View {
    @Environment(OBDService.self) var obdService
    @Environment(Garage.self) var garage
    @Binding var statusMessage: String?
    @State var isLoading = false
    @State private var shouldGrow = false
    @State private var whiteStreakProgress: CGFloat = 0.0

    var body: some View {
        VStack(spacing: 20) {
            if obdService.connectionState != .connectedToVehicle {
                ConnectButton(isLoading: $isLoading, shouldGrow: $shouldGrow) {
                    connectButtonAction()
                }
            }

            CarInfoView(whiteStreakProgress: whiteStreakProgress, statusMessage: $statusMessage)
                .padding(.horizontal)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
    }

    @MainActor
    private func connectButtonAction() {
        Task {
            guard !isLoading else { return }
            self.isLoading = true
            let notificationFeedback = UINotificationFeedbackGenerator()
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.prepare()
            notificationFeedback.prepare()
            impactFeedback.impactOccurred()

            var vehicle = garage.currentVehicle ?? garage.newVehicle()

            do {
                self.statusMessage = "Initializing OBD Adapter (BLE)"

                vehicle.obdinfo = try await obdService.startConnection()
                vehicle.obdinfo?.supportedPIDs = await obdService.getSupportedPIDs()

                garage.updateVehicle(vehicle)
                garage.setCurrentVehicle(to: vehicle)

                notificationFeedback.notificationOccurred(.success)
                withAnimation {
                    self.statusMessage = "Connected to Vehicle"
                    self.isLoading = false
                    animateWhiteStreak()
                }

                Task {
                    try? await Task.sleep(for: .seconds(2.5))
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.statusMessage = nil
                    }
                }

            } catch {
                notificationFeedback.notificationOccurred(.error)
                self.statusMessage = "Error Connecting to Vehicle"
                withAnimation {
                    self.isLoading = false
                }
            }
        }
    }

    func animateWhiteStreak() {
        withAnimation(.linear(duration: 2.0)) {
            self.whiteStreakProgress = 1.0 // Animate to 100%
        }
    }
}

struct ConnectButton: View {
    @Binding var isLoading: Bool
    @Binding var shouldGrow: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if !isLoading {
                    Text("START")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .transition(.opacity)
                    Ellipse()
                        .foregroundStyle(Color.clear)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                                .scaleEffect(shouldGrow ? 1.5 : 1.0)
                                .opacity(shouldGrow ? 0.0 : 1.0)
                        )
                        .onAppear {
                            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                                self.shouldGrow = true
                            }
                        }
                } else {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
        }
        .buttonStyle(CustomButtonStyle())
        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 80, height: 80)
            .background(content: {
                Circle()
                    .fill(Color(red: 39/255, green: 110/255, blue: 241/255))
            })
            .scaleEffect(configuration.isPressed ? 1.5 : 1)
            .animation(.easeOut(duration: 0.3), value: configuration.isPressed)
    }
}

struct CarInfoView: View {
    @Environment(OBDService.self) var obdService
    @Environment(Garage.self) var garage
    let whiteStreakProgress: CGFloat
    @Binding var statusMessage: String?

    var body: some View {
        VStack {
            VStack(alignment: .center) {
                if let statusMessage = statusMessage {
                    Text(statusMessage)
                } else {
                    Text("\(garage.currentVehicle?.year ?? "") \(garage.currentVehicle?.make ?? "") \(garage.currentVehicle?.model ?? "")")
                }
            }
            .font(.system(size: 22, weight: .bold, design: .rounded))
            .bold()
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(content: {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .trim(from: 0, to: whiteStreakProgress)
                            .stroke(
                                AngularGradient(
                                    gradient: .init(colors: [.green]),
                                    center: .center,
                                    startAngle: .zero,
                                    endAngle: .degrees(360)
                                ),
                                style: StrokeStyle(lineWidth: 1, lineCap: .round)
                            )
                    )
            })

            VStack {
                HStack {
                    Text("VIN")
                    Spacer()
                    Text(garage.currentVehicle?.obdinfo?.vin ?? "")
                }
                HStack {
                    Text("Protocol")
                    Spacer()
                    Text(garage.currentVehicle?.obdinfo?.obdProtocol?.description ?? "")
                }
                HStack {
                    Text("ELM connection")
                    Spacer()
                    Text(obdService.connectionState == .connectedToAdapter || obdService.connectionState == .connectedToVehicle ? "Connected" : "disconnected")
                        .foregroundStyle(obdService.connectionState == .connectedToAdapter || obdService.connectionState == .connectedToVehicle ? .green : .red)
                }

                HStack {
                    Text("ECU connection")
                    Spacer()
                    Text(obdService.connectionState == ConnectionState.connectedToVehicle ? "Connected" : "disconnected")
                        .foregroundStyle(obdService.connectionState == ConnectionState.connectedToVehicle ? .green : .red)
                }
            }
            .font(.system(size: 14, weight: .semibold))
            .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity)
    }
}
