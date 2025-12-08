//
//  BackgroundView.swift
//  SLOWTRUTH
//
//  Created by Jules on 2/28/24.
//

import SwiftUI

struct BackgroundView: View {
    @Binding var isDemoMode: Bool

    var body: some View {
        ZStack {
            Color.dashboardBackground
                .ignoresSafeArea()

            if isDemoMode {
                ZStack {
                    Text("Demo Mode")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundStyle(Color.gray.opacity(0.1))
                        .offset(y: -5)
                        .rotationEffect(.degrees(-30))

                    Text("Demo Mode")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundStyle(Color.white.opacity(0.1))
                        .offset(y: 2)
                        .rotationEffect(.degrees(-30))
                }
                .allowsHitTesting(false)
            }
        }
    }
}

#Preview {
    BackgroundView(isDemoMode: .constant(true))
}
