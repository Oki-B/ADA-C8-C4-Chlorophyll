//
//  ShutterButton.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 18/06/25.
//

import SwiftUI

struct ShutterButton: View {
    private let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            Label {
                Text("Take Photo")
            } icon: {
                ZStack {
                    Circle()
                        .strokeBorder(.white, lineWidth: !isEnabled ? 3 : 1)
                        .frame(
                            width: !isEnabled ? 65 : 62,
                            height: !isEnabled ? 65 : 62
                        )
                        .animation(
                            .interpolatingSpring(
                                mass: 2.0,
                                stiffness: 100.0,
                                damping: 10,
                                initialVelocity: 0
                            ),
                            value: !isEnabled
                        )
                    Circle()
                        .fill(.white)
                        .frame(
                            width: !isEnabled ? 55 : 50,
                            height: !isEnabled ? 55 : 50
                        )
                        .animation(
                            .interpolatingSpring(
                                mass: 2.0,
                                stiffness: 100.0,
                                damping: 10,
                                initialVelocity: 0
                            ),
                            value: !isEnabled
                        )
                }
            }
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
    }
}

#Preview {
    ShutterButton(action: {})
}
