//
//  OnboardingView.swift
//  FlipTimer
//
//  Created by Dan on 11/12/2020.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack {
            Spacer()

            Text("Welcome to Flip Timer")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            VStack(spacing: 24) {
                FeatureCell(
                    imageName: "text.badge.checkmark",
                    title: "Title",
                    subtitle: "Subtitle"
                )
                FeatureCell(
                    imageName: "text.badge.checkmark",
                    title: "Title",
                    subtitle: "Subtitle"
                )
                FeatureCell(
                    imageName: "text.badge.checkmark",
                    title: "Title",
                    subtitle: "Subtitle"
                )
            }

            // TODO: find out if spacers can have weight
            Spacer()
            Spacer()

            Button(action: {}, label: {
                HStack {
                    Spacer()
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            })
        }
        .padding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
