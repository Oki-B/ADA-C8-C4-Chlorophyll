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
    let idealValue: Bool
    
    init(iconName: String, titleLeading: String, valueTrailing: String, idealValue: Bool) {
        self.iconName = iconName
        self.titleLeading = titleLeading
        self.valueTrailing = valueTrailing
        self.idealValue = idealValue
    }
    
    init(titleLeading: String, valueTrailing: String, idealValue: Bool) {
        self.iconName = "square.grid.2x2"
        self.titleLeading = titleLeading
        self.valueTrailing = valueTrailing
        self.idealValue = idealValue
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            Image(systemName: iconName)
                .foregroundStyle(.cultured300)
            Text(titleLeading)
                .font(.baseMedium)
                .foregroundStyle(.cultured300)
                .foregroundColor(.darkCharcoal700)
            Spacer()
            Text(valueTrailing)
                .font(.h4)
                .foregroundStyle(.cultured300)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(idealValue ? .mughalGreen500: .electricRed300)
    }
}

#Preview {
    ListItem(titleLeading: "Nitrogen", valueTrailing: "76%", idealValue: true)
}


// bg list
// ideal: mughalGreen300
// notideal : electricRed300

//
