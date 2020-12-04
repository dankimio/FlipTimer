import SwiftUI
import AVFoundation

// Source: https://gist.github.com/skl/a093291abc0a90a640e50f78888456e7
class ProximityObserver {
    @objc func didChange(notification: NSNotification) {
        guard let device = notification.object as? UIDevice else { return }

        // BeginRecording, EndRecording
        let systemSound = device.proximityState ? SystemSoundID(1117) : SystemSoundID(1118)
        AudioServicesPlayAlertSound(systemSound)
    }
}

struct ContentView: View {
    @State private var showSettingsView = false
    @State var timerMode: TimerMode = .paused

    var proximityObserver = ProximityObserver()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("24:59")
                    .font(.system(size: 96, weight: .regular, design: .monospaced))
                    .padding(.bottom, 30)
                
                VStack {
                    if timerMode == .initial {
                        Text("Flip your phone to start the timer")
                            .foregroundColor(Color(UIColor.systemGray))
                    }

                    if timerMode == .paused {
                        Button(action: {}, label: {
                            HStack {
                                Spacer()
                                Text("Stop").foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(12)
                        })
                    }
                }.padding(.horizontal)

                Spacer().frame(maxHeight: 200)
            }
            .padding()
            .navigationBarItems(
                trailing: Button(
                    action: { showSettingsView.toggle() },
                    label: { Image(systemName: "gearshape.fill").imageScale(.large) }
                )
            )
        }
        .sheet(isPresented: $showSettingsView, content: {
            SettingsView(showSettingsView: $showSettingsView)
        })
        .onAppear(perform: {
            print("onAppear")

            activateProximitySensor()
        })
        .onDisappear(perform: {
            print("onDisappear")

            deactivateProximitySensor()
        })
    }

    func activateProximitySensor() {
        print("activateProximitySensor")
        UIDevice.current.isProximityMonitoringEnabled = true

        if UIDevice.current.isProximityMonitoringEnabled {
            NotificationCenter.default.addObserver(
                proximityObserver,
                selector: #selector(proximityObserver.didChange),
                name: UIDevice.proximityStateDidChangeNotification,
                object: UIDevice.current
            )
        }
    }

    func deactivateProximitySensor() {
        print("deactivateProximitySensor")
        UIDevice.current.isProximityMonitoringEnabled = false
        NotificationCenter.default.removeObserver(
            proximityObserver,
            name: UIDevice.proximityStateDidChangeNotification,
            object: UIDevice.current
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(timerMode: .paused)
    }
}
