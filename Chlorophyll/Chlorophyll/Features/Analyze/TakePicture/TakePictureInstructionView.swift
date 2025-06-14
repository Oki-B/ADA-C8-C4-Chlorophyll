//
//  TakePictureInstructionView.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 15/06/25.
//

import SwiftUI

struct TakePictureInstructionView: View {
    var body: some View {
        VStack {
            StepBar(currentStep: 1)
            
            Spacer()
            Text("Follow these simple steps before taking the photo")
                .font(.h3)
                .foregroundStyle(.darkCharcoal700)
                .multilineTextAlignment(.center)
            Spacer()
            
            VStack(spacing: 24) {
                // Step 1
                VStack(spacing: 12) {
                    Image("soil-spooned")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 225, height: 150)
                        .clipped()
                        .cornerRadius(16)
                        
                    HStack(alignment: .top) {
                        Text("1")
                            .font(.baseMedium)
                        
                        Text("Scoop 2 tablespoons of soil form near your plant's roots")
                            .font(.baseMedium)
//                            .multilineTextAlignment(.center)
                    }
                        .foregroundStyle(.darkCharcoal700)
                }
                
                // Step 2
                VStack(spacing: 12) {
                    Image("soil-sample")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 225, height: 150)
                        .clipped()
                        .cornerRadius(16)
                        
                    HStack(alignment: .top) {
                        Text("2")
                            .font(.baseMedium)
                        
                        Text("Spread the soil evenly oon a clean surface, use white surface paper for better contrast")
                            .font(.baseMedium)
//                            .multilineTextAlignment(.center)
                    }
                        .foregroundStyle(.darkCharcoal700)
                }
            }
            .frame(maxWidth: 280)
            
            Spacer()
            Spacer()
            
            ActionButton(title: .takePicture, action: { })
                
                
        }
        .padding()
    }
}

#Preview {
    TakePictureInstructionView()
}
