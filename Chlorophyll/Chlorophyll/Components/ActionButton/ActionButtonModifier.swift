//
//  ActionButtonModifier.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 14/06/25.
//

import SwiftUI

struct ActionButtonLabelTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.cultured500)
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(.mughalGreen500)
            .cornerRadius(8)
    }
}


