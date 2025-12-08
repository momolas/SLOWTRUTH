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
    let metrics: [MetricItem] = [
        MetricItem(title: "Carburant", value: "80%", icon: "fuelpump.fill", valueColor: .gray),
        MetricItem(title: "Pneus", value: "OK", icon: "exclamationmark.circle", valueColor: .dashboardAccentGreen),
        MetricItem(title: "Batterie", value: "95%", icon: "battery.100", valueColor: .gray),
        MetricItem(title: "Kilométrage", value: "123,456 km", icon: "gauge", valueColor: .gray)
    ]

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
    MetricsGrid()
        .padding()
        .background(Color.dashboardBackground)
}
