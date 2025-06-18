//
//  StartAnalyzeView.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 15/06/25.
//

import SwiftUI

struct StartAnalyzeView: View {

    let steps = Instructions.instructions

    var body: some View {
        NavigationStack {
            
            Spacer()

            VStack(alignment: .leading, spacing: 10) {
                Text("Calathea")
                    .font(.h1)
                Text("Find out your calathea condition, They need you")
                    .font(.h3)
                    .foregroundStyle(.midGreenYellow700)
                    .lineSpacing(10)
            }

            Spacer()

            VStack(alignment: .leading) {
                ForEach(steps) { step in
                    HStack (spacing: 40){
                        Rectangle()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.green)

                        Text(step.description)
                            .font(.h4)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundStyle(.darkCharcoal300)
                            .multilineTextAlignment(.leading)

                            
                    }
                    .padding(.horizontal)
                }
            }

            Spacer()
            Spacer()

            NavigationLink(destination: { TakePictureView() }) {
                Text("Let's Begin")
                    .modifier(ActionButtonLabelTextStyle())
            }

        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    StartAnalyzeView()
}
