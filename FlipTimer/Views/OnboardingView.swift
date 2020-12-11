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
                Text("1")
                Text("2")
                Text("3")
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
