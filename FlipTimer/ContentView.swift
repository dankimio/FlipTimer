import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationView {
      VStack {
        Text("25:00")
          .font(
            .system(size: 96, weight: .light, design: .monospaced)
          )
      }.navigationBarItems(trailing: Button(action: {
        print("Settings")
      }) {
        Image(systemName: "gearshape.fill")
      })
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
