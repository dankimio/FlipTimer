import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationView {
      VStack {
        Text("25:00")
          .font(
            .system(size: 84, weight: .regular, design: .monospaced)
          )
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
