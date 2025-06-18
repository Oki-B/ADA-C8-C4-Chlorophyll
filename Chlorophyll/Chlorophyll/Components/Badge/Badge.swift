//
//  Badge.swift
//  Chlorophyll
//
//  Created by Dimaseditiya on 18/06/25.
//

import SwiftUI

struct BoldBadge: View {
    let imageName: String
    let text: String
    
    init(imageName: String = "checkmark.circle.fill", text: String = "Tips") {
        self.imageName = imageName
        self.text = text
    }
    
    var body: some View {
        HStack(alignment: .center, spacing:  8) {
            Image(systemName: imageName)
                .foregroundStyle(.neutral100)
            Text(text)
                .font(.baseMedium)
                .foregroundStyle(.neutral100)
                .foregroundColor(.darkCharcoal700)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.mughalGreen500)
        .cornerRadius(5)
    }
}

#Preview {
    BoldBadge()
}
