//
//  DashboardHeaderView.swift
//  SLOWTRUTH
//
//  Created by Jules on 10/27/23.
//

import SwiftUI

struct DashboardHeaderView: View {
    var onProfileTap: () -> Void = {}

    var body: some View {
        HStack {
            Spacer()
            Text("Tableau de bord")
                .font(.headline)
                .bold()
                .foregroundStyle(.white)
            Spacer()
            Button(action: onProfileTap) {
                Image(systemName: "person.circle")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
        }
        .padding()
        .background(Color.dashboardBackground)
    }
}

#Preview {
    DashboardHeaderView()
}
