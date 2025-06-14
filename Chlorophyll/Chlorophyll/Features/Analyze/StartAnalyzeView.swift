//
//  StartAnalyzeView.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 15/06/25.
//

import SwiftUI

struct StartAnalyzeView: View {
    var body: some View {
        VStack {
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
            Spacer()

            Image("CalatheaVector")
                .resizable()
                .scaledToFit()
                .frame(width: 329, height: 247)

            Spacer()
            Spacer()
            
            ActionButton(title: .start, action: {
                // write action code here
            })

        }
        .padding()
    }
}

#Preview {
    StartAnalyzeView()
}
