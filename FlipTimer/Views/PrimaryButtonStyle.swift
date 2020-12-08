//
//  PrimaryButtonStyle.swift
//  FlipTimer
//
//  Created by Dan on 08/12/2020.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding()
            .background(Color.accentColor)
            .cornerRadius(12)
    }
}
