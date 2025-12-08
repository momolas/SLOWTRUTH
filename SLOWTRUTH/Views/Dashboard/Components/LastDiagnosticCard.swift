//
//  LastDiagnosticCard.swift
//  SLOWTRUTH
//
//  Created by Jules on 10/27/23.
//

import SwiftUI

struct LastDiagnosticCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Dernier diagnostic")
                .font(.headline)
                .foregroundStyle(.white)

            Text("23/10/2023 - 2 problèmes")
                .font(.subheadline)
                .foregroundStyle(.gray)

            Button(action: {}) {
                Text("Voir rapport")
                    .font(.body)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue, in: .rect(cornerRadius: 10))
                    .foregroundStyle(.white)
            }
            .frame(width: 150) // Adjust size as needed or remove frame for full width
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.dashboardCard, in: .rect(cornerRadius: 15))
    }
}

#Preview {
    LastDiagnosticCard()
        .padding()
        .background(Color.dashboardBackground)
}
