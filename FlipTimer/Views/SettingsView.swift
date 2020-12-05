import SwiftUI

struct SettingsView: View {
    @Binding var showSettingsView: Bool

    let twitterURL = URL(string: "https://twitter.com/dankimio")!
    let websiteURL = URL(string: "https://dankim.io")

    var body: some View {
        NavigationView {
            List {
                if false {
                    Section(
                        header: Text("Mode"),
                        footer: Text("Timer will be reset if the phone is unflipped")
                    ) {
                        Toggle("Strict mode", isOn: .constant(true))
                    }
                }

                Section(header: Text("Help")) {
                    NavigationLink("Share Feedback", destination: Text(""))
                }

                if false {
                    Section(header: Text("Follow")) {
                        Link("Follow on Twitter", destination: twitterURL)
                        Link("Open Website", destination: twitterURL)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .navigationBarItems(
                trailing: Button(
                    action: { showSettingsView.toggle() },
                    label: { Text("Done") }
                )
            )
        }
    }

    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView(showSettingsView: .constant(true))
        }
    }
}
