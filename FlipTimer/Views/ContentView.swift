import SwiftUI

struct ContentView: View {
    @AppStorage("onboardingDismissed") private var onboardingDismissed = false

    var body: some View {
        if onboardingDismissed {
            TimerView()
        } else {
            OnboardingView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
