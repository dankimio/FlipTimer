import SwiftUI

struct ContentView: View {
    @State private var showSettingsView = false
    @State var timerMode: TimerMode = .paused
    
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(timerMode: .paused)
    }
}
