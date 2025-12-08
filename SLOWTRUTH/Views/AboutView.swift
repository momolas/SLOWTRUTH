//
//  AboutView.swift
//  SLOWTRUTH
//
//  Created by kemo konteh on 10/1/23.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            BackgroundView(isDemoMode: .constant(false))

            VStack(spacing: 100) {
                Text("SLOWTRUTH Version 1.0")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.bottom, 10)
                VStack {
                    Text(
                     """
                        SLOWTRUTH lets you monitor your car's health and
                        performance in real-time. It also lets you diagnose
                        your car's problems and provides you with a
                        solution to fix them.
                     """
                    )
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.bottom, 10)

                    Text("Dedicated to my Dad\n Lang Konteh")
                        .multilineTextAlignment(.trailing)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.gray)
                        .padding(.bottom, 10)
                }

                VStack {
                    Text("©2023 Konteh Inc")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.gray)

                    Text("All rights reserved")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.gray)
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Select a Make")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                }

            }

        }
    }
}

#Preview {
    AboutView()
}
