//
//  MetricsGrid.swift
//  SLOWTRUTH
//
//  Created by Jules on 10/27/23.
//

import SwiftUI

struct MetricItem: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let icon: String
    let valueColor: Color
}

struct MetricsGrid: View {
    var fuelLevel: String
    var batteryVoltage: String
    var tireStatus: String = "Non dispo"
    var mileage: String = "Non dispo"

    var fuelColor: Color = .gray
    var batteryColor: Color = .gray

    var metrics: [MetricItem] {
        [
            MetricItem(title: "Carburant", value: fuelLevel, icon: "fuelpump.fill", valueColor: fuelColor),
            MetricItem(title: "Pneus", value: tireStatus, icon: "exclamationmark.circle", valueColor: .gray),
            MetricItem(title: "Batterie", value: batteryVoltage, icon: "battery.100", valueColor: batteryColor),
            MetricItem(title: "Kilométrage", value: mileage, icon: "gauge", valueColor: .gray)
        ]
    }

    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(metrics) { metric in
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: metric.icon)
                        .font(.title2)
                        .foregroundStyle(.gray)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(metric.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)

                        Text(metric.value)
                            .font(.subheadline)
                            .foregroundStyle(metric.valueColor)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.dashboardCard, in: .rect(cornerRadius: 15))
            }
        }
    }
}

#Preview {
    MetricsGrid(fuelLevel: "80%", batteryVoltage: "12.4 V")
        .padding()
        .background(Color.dashboardBackground)
}
