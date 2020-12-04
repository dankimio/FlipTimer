import SwiftUI

struct ContentView: View {
    @State private var showSettingsView = false

    var body: some View {
        NavigationView {
            VStack {
                Text("24:59")
                    .font(.system(size: 96, weight: .regular, design: .monospaced))
                    .padding(.bottom, 30)

                VStack {
                    Text("Flip your phone to start the timer")
                        .foregroundColor(Color(UIColor.systemGray))
                }

                Spacer().frame(maxHeight: 200)
            }
            .navigationBarItems(
                trailing: Button(
                    action: { showSettingsView.toggle() },
                    label: { Image(systemName: "gearshape.fill") }
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
        ContentView()
    }
}
