//
//  ToggleButton.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 18/06/25.
//

import SwiftUI

struct CameraOptionToggle: View {
    private let textLabel: String
    @Binding private var toggleValue: Bool

    init(textLabel: String, toggleValue: Binding<Bool>) {
        self.textLabel = textLabel
        self._toggleValue = toggleValue
    }

    var body: some View {
        HStack {
            Text(textLabel).font(.caption).padding(.trailing, 4)
                .foregroundColor(.white)
            Toggle("", isOn: $toggleValue).fixedSize().labelsHidden()
        }
    }
}

#Preview {
    CameraOptionToggle(textLabel: "Test", toggleValue: .constant(true))
}
