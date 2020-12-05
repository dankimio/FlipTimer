import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var showSettingsView = false

    @ObservedObject var timerManager = TimerManager()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("\(timerManager.timeLeft)")
                    .font(.system(size: 96, weight: .regular, design: .monospaced))
                    .padding(.bottom, 30)
                    .minimumScaleFactor(0.5)
                
                VStack {
                    if timerManager.timerMode == .initial {
                        Text("Flip your phone to start the timer")
                            .foregroundColor(Color(UIColor.systemGray))
                    }

                    if timerManager.timerMode == .paused {
                        Button(
                            action: {
                                timerManager.stop()
                            },
                            label: {
                                HStack {
                                    Spacer()
                                    Text("Stop").foregroundColor(.white)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.accentColor)
                                .cornerRadius(12)
                            }
                        )
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

    private func activateProximitySensor() {
        print("activateProximitySensor")

        UIDevice.current.isProximityMonitoringEnabled = true
        guard UIDevice.current.isProximityMonitoringEnabled else { return }

        NotificationCenter.default.addObserver(
            timerManager,
            selector: #selector(timerManager.proximityDidChange),
            name: UIDevice.proximityStateDidChangeNotification,
            object: UIDevice.current
        )
    }

    private func deactivateProximitySensor() {
        print("deactivateProximitySensor")
        
        UIDevice.current.isProximityMonitoringEnabled = false
        NotificationCenter.default.removeObserver(
            timerManager,
            name: UIDevice.proximityStateDidChangeNotification,
            object: UIDevice.current
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
