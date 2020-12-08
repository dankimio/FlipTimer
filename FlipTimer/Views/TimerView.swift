import SwiftUI
import AVFoundation

struct TimerView: View {
    @State private var showSettingsView = false

    @StateObject var timerManager = TimerManager()
    
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

            timerManager.activateProximitySensor()
        })
        .onDisappear(perform: {
            print("onDisappear")

            timerManager.deactivateProximitySensor()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TimerView()
        }
    }
}
