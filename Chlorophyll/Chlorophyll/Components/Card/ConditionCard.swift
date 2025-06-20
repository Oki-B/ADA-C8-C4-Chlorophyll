//
//  ConditionCard.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 19/06/25.
//

import SwiftUI

struct ConditionCard: View {
    let imageName: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .frame(width: 32, height: 32)
                .scaledToFill()
                .clipped()
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.baseRegular)
                Text(value)
                    .font(.h3)
            }
            
            Spacer()
        }
        .frame(maxWidth: 135, maxHeight: 35)
        .padding(.horizontal, 6)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color:.black, radius: 1, x: 0.5, y: 0.5)
        
    }
}

#Preview {
    ConditionCard(imageName: "icon_temperature", title: "Temperature", value: "16-30°C")
}
