import SwiftUI
import AVFoundation

struct SettingsView: View {
    @Binding var showSettingsView: Bool

    @StateObject private var viewModel = SettingsViewModel()

    @State private var selected = 1

    let twitterURL = URL(string: "https://twitter.com/dankimio")!
    let websiteURL = URL(string: "https://fliptimer.dan.kim")!
    let feedbackURL = URL(string: "https://forms.gle/AhLV8vtPq4511zij6")!

    var body: some View {
        NavigationView {
            List {
                Section(
                    header: Text("Mode"),
                    footer: Text("Timer will be reset if the phone is unflipped.")
                ) {
                    Toggle("Strict Mode", isOn: $viewModel.strictMode)
                }

                if Flashlight.shared.hasFlashlight {
                    Section(
                        header: Text("Notification"),
                        footer: Text("Flash when the time is up.")
                    ) {
                        Toggle("Flash", isOn: $viewModel.flash)
                    }
                }

                Section(header: Text("Icon")) {
                    // EmptyView required to hide title
                    // Source: https://stackoverflow.com/a/70762013/2505156
                    Picker(
                        selection: $selected, label: EmptyView()
                    ) {
                        HStack(spacing: 16) {
                            Image("AppIconImage")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .frame(width: 72, height: 72)

                            Text("Default")
                        }
                        .tag(0)
                        
                        HStack(spacing: 16) {
                            Image("AppIconClassicDark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .frame(width: 72, height: 72)

                            Text("Classic dark")
                        }
                        .tag(1)
                        
                        HStack(spacing: 16) {
                            Image("AppIconClassicLight")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .frame(width: 72, height: 72)

                            Text("Classic light")
                        }
                        .tag(2)
                    }
                    .pickerStyle(.inline)
                }

                Section(header: Text("Help")) {
                    Link(destination: feedbackURL, label: {
                        HStack {
                            Text("Leave Feedback")
                            Spacer()
                            Image(systemName: "arrow.up.forward")
                                .imageScale(.small)
                                .foregroundColor(.accentColor)
                        }
                    })
                }

                Section(header: Text("About")) {
                    Link(destination: websiteURL, label: {
                        HStack {
                            Text("Open Website")
                            Spacer()
                            Image(systemName: "arrow.up.forward")
                                .imageScale(.small)
                                .foregroundColor(.accentColor)
                        }
                    })
                    Link(destination: twitterURL, label: {
                        HStack {
                            Text("Follow on Twitter")
                            Spacer()
                            Image(systemName: "arrow.up.forward")
                                .imageScale(.small)
                                .foregroundColor(.accentColor)
                        }
                    })
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .navigationBarItems(
                trailing: Button(
                    action: { showSettingsView = false },
                    label: { Text("Done") }
                )
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSettingsView: .constant(true))
    }
}
