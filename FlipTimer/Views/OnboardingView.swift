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
                    imageName: "hourglass",
                    title: "Timer Interval",
                    subtitle: "Tap on the timer label and choose your timer length."
                )
                FeatureCell(
                    imageName: "arrow.turn.right.down",
                    title: "No Screen Time",
                    subtitle: "Put your device on the table screen facing down to start the timer."
                )
                FeatureCell(
                    imageName: "speaker.wave.2.fill",
                    title: "Take a Break",
                    subtitle: "You will hear a sound when the timer is finished. Take a break and restart when you're ready!"
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
