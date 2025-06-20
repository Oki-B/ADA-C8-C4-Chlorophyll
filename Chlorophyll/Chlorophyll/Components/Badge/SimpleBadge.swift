//
//  SimpleBadge.swift
//  Chlorophyll
//
//  Created by Dimaseditiya on 18/06/25.
//

import SwiftUI

struct SimpleBadge: View {
    let imageName: String
    let text: String
    
    init(imageName: String = "checkmark.circle.fill", text: String = "Calathea") {
        self.imageName = imageName
        self.text = text
    }
    
    var body: some View {
        HStack(alignment: .center, spacing:  8) {
            Image(systemName: imageName)
                .foregroundStyle(.mughalGreen500)
            Text(text)
                .font(.smallMedium)
                .foregroundStyle(.darkCharcoal500)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.neutral500)
        .cornerRadius(5)
    }
}

#Preview {
    SimpleBadge()
}
