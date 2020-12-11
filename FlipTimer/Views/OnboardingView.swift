import SwiftUI

struct OnboardingView: View {
    @AppStorage("onboardingDismissed") private var onboardingDismissed = false

    var body: some View {
        VStack {
            Spacer()

            Text("Welcome to\nFlip Timer!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            VStack(spacing: 24) {
                FeatureCell(
                    imageName: "text.badge.checkmark",
                    title: "Feature 1",
                    subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
                )
                FeatureCell(
                    imageName: "text.badge.checkmark",
                    title: "Feature 2",
                    subtitle: "Maecenas a posuere nunc. Morbi faucibus, massa eget vehicula."
                )
                FeatureCell(
                    imageName: "text.badge.checkmark",
                    title: "Feature 3",
                    subtitle: "Etiam non pellentesque ligula. Aenean eleifend erat tincidunt."
                )
            }
            .padding()

            // TODO: find out if spacers can have weight
            Spacer()
            Spacer()

            Button(
                action: {
                    onboardingDismissed = true
                },
                label: {
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
