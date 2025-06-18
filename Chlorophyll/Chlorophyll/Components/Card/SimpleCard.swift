//
//  SimpleCard.swift
//  Chlorophyll
//
//  Created by Dimaseditiya on 18/06/25.
//

import SwiftUI

struct SimpleCard: View {
    let title: String
    let content: String
    
    init(title: String = "Calathea Watering Guide", content: String = "Water your Calathea when the top inch of soil feels dry. Keep the soil lightly moist but not soggy, as overwatering can cause root rot. Use filtered or distilled water (or rainwater) to avoid brown leaf tips from tap water chemicals. Ensure good drainage and high humidity for best growth.") {
        self.title = title
        self.content = content
    }
    
    var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                BoldBadge()
                    .padding(.horizontal, 16)
                Text(title)
                    .font(.h3)
                    .foregroundColor(.darkCharcoal700)
                    .padding(.horizontal, 16)
                Text(content)
                    .font(.baseMedium)
                    .foregroundColor(.darkCharcoal500)
                    .padding(.horizontal, 16)
            }
//            .padding()
            .background(Color.white)
            .cornerRadius(8) // 🎯 Rounded corners
            .shadow(color: .white, radius: 8, x: 0, y: 4)
            
        }
}

#Preview {
    SimpleCard()
}
