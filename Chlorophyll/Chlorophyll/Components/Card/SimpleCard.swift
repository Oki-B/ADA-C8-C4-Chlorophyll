//
//  SimpleCard.swift
//  Chlorophyll
//
//  Created by Dimaseditiya on 18/06/25.
//

import SwiftUI

struct SimpleCard: View {
    let title: String
    let content: [String]

    init(
        title: String = "Calathea Watering Guide",
        content: [String] = [
            "Water when the top inch feels dry.",
            "Use filtered or rainwater to avoid leaf browning.",
            "Keep humidity high and soil well-drained.",
        ]
    ) {
        self.title = title
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            BoldBadge()

            VStack(alignment: .leading) {
                Text(title)
                    .font(.h3)
                    .foregroundColor(.darkCharcoal700)
                    .padding(.vertical, 6)
                ForEach(content, id: \.self) { line in
                    HStack(alignment:.top, spacing: 4) {
                        Text("・")
                        Text(line)
                            .font(.baseMedium)
                            .foregroundColor(.darkCharcoal500)
                    }

                }
            }

        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)  // 🎯 Rounded corners
        .shadow(color: .gray.opacity(0.4), radius: 2.5, x: 0.5, y: 4)

    }
}

#Preview {
    SimpleCard()
}
