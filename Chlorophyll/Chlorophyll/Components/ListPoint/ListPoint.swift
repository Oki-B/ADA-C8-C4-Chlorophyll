//
//  ListPoint.swift
//  Chlorophyll
//
//  Created by Dimaseditiya on 18/06/25.
//

import SwiftUI


struct ListItem: View {
    let iconName: String
    let titleLeading: String
    let valueTrailing: String
    
    init(iconName: String, titleLeading: String, valueTrailing: String) {
        self.iconName = iconName
        self.titleLeading = titleLeading
        self.valueTrailing = valueTrailing
    }
    
    init(titleLeading: String, valueTrailing: String) {
        self.iconName = "square.grid.2x2"
        self.titleLeading = titleLeading
        self.valueTrailing = valueTrailing
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            Image(systemName: iconName)
                .foregroundStyle(.neutral400)
            Text(titleLeading)
                .font(.baseMedium)
                .foregroundStyle(.neutral400)
                .foregroundColor(.darkCharcoal700)
            Spacer()
            Text(valueTrailing)
                .font(.h4)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.white)
    }
}

#Preview {
    ListItem(titleLeading: "Nitrogen", valueTrailing: "76%")
}
