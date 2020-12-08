import SwiftUI
import AVFoundation

struct TimerView: View {
    @StateObject var viewModel = TimerViewModel()

    @State private var showSettingsView = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("\(viewModel.timeLeft)")
                    .font(.system(size: 96, weight: .regular, design: .monospaced))
                    .padding(.bottom, 30)
                    .minimumScaleFactor(0.5)
                    .onTapGesture {
                        guard viewModel.timerMode == .initial else { return }

                        viewModel.shouldOpenTimerLengthPicker = true
                    }
                
                VStack {
                    if viewModel.timerMode == .initial {
                        Text("Flip your device to start the timer")
                            .foregroundColor(Color(UIColor.systemGray))
                    }

                    if viewModel.timerMode == .paused {
                        Button(
                            action: {
                                viewModel.stop()
                            },
                            label: {
                                HStack {
                                    Spacer()
                                    Text("Stop").foregroundColor(.white)
                                    Spacer()
                                }
                            }
                        )
                        .buttonStyle(PrimaryButtonStyle())
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
        .actionSheet(isPresented: $viewModel.shouldOpenTimerLengthPicker, content: {
            var buttons = TimerLength.allCases.map { length in
                ActionSheet.Button.default(Text(length.name)) {
                    viewModel.timerLength = length
                }
            }
            buttons.append(.cancel())

            return ActionSheet(
                title: Text("Timer length"),
                message: Text("Choose timer length"),
                buttons: buttons
            )
        })
        .onAppear(perform: {
            print("onAppear")

            viewModel.startMonitoring()
        })
        .onDisappear(perform: {
            print("onDisappear")

            viewModel.stopMonitoring()
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
