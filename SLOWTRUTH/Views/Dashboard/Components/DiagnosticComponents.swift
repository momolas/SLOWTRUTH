//
//  DiagnosticComponents.swift
//  SLOWTRUTH
//
//  Created by Jules on 10/27/23.
//

import SwiftUI

struct DiagnosticProgressView: View {
    let progress: Double // 0.0 to 1.0

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 25)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LinearGradient(colors: [.blue, Color(red: 0.4, green: 0.2, blue: 1.0)], startPoint: .topLeading, endPoint: .bottomTrailing),
                    style: StrokeStyle(lineWidth: 25, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)

            VStack(spacing: 5) {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.4, green: 0.4, blue: 1.0)) // Light blue/purple

                if progress < 1.0 {
                    Text("Analyse en cours...")
                        .font(.body)
                        .foregroundStyle(.gray)
                } else {
                    Text("Terminé")
                        .font(.body)
                        .foregroundStyle(.gray)
                }
            }
        }
        .frame(width: 250, height: 250)
    }
}

struct DiagnosticResultRow: View {
    let systemName: String
    let status: String
    let isError: Bool

    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(isError ? Color.orange.opacity(0.2) : Color.green.opacity(0.2))
                    .frame(width: 50, height: 50)

                Image(systemName: isError ? "exclamationmark" : "checkmark")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(isError ? Color.orange : Color.green)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(systemName)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                Text(status)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }

            Spacer()
        }
        .padding()
        .background(Color.dashboardCard, in: .rect(cornerRadius: 15))
    }
}

#Preview {
    ZStack {
        Color.dashboardBackground.ignoresSafeArea()
        VStack {
            DiagnosticProgressView(progress: 0.75)
            DiagnosticResultRow(systemName: "Système moteur", status: "Aucun problème détecté", isError: false)
            DiagnosticResultRow(systemName: "Système de freinage", status: "Code P0571", isError: true)
        }
        .padding()
    }
}
