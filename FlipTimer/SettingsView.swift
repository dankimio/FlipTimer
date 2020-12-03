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
                Section(header: Text("Mode")) {
                    Text("Strict mode")
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
