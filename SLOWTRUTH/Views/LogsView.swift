//
//  LogsView.swift
//  SLOWTRUTH
//
//  Created by kemo konteh on 2/28/24.
//

import SwiftUI

struct LogsView: View {
    @Binding var isDemoMode: Bool

    var body: some View {
        ZStack {
            BackgroundView(isDemoMode: $isDemoMode)

            VStack {
                Text("Historique")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding()

                Spacer()

                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 60))
                    .foregroundStyle(.gray)
                    .padding()

                Text("Aucun historique disponible")
                    .font(.headline)
                    .foregroundStyle(.gray)

                Spacer()
            }
        }
    }
}

#Preview {
    LogsView(isDemoMode: .constant(false))
}
