//
//  SettingsView.swift
//  FlipTimer
//
//  Created by Dan on 04/12/2020.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showSettingsView: Bool

    var body: some View {
        NavigationView {
            List {
                Section(
                    header: Text("Mode"),
                    footer: Text("Timer will be reset if the phone is unflipped")
                ) {
                    Toggle("Strict mode", isOn: .constant(true))
                }
                Section(header: Text("Help")) {
                    NavigationLink("Open Tutorial", destination: Text(""))
                    NavigationLink("Share Feedback", destination: Text(""))
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSettingsView: .constant(true))
    }
}
