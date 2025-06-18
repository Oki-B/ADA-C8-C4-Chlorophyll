//
//  AnalyzeView.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 19/06/25.
//

import SwiftUI

struct AnalyzeView: View {
    @State private var progress: CGFloat = 0.0
    @State private var percentage: Int = 0
    @State private var navigateToResult = false
    
    let pH : Double
    let nitrogen : Double
    let phosphorus : Double
    let potassium : Double
    let plantHealth : String

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 30) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Result")
                                .font(.h1)
                            Spacer()
                            Button {

                            } label: {
                                Image(systemName: "x.circle")
                                    .foregroundStyle(.darkCharcoal300)
                                    .font(.title)
                            }
                        }

                        HStack(spacing: 24) {
                            Image("happy")
                                .resizable()
                                .frame(width: 125, height: 125)
                            VStack (alignment: .leading) {
                                Text(plantHealth)
                                    .font(.baseMedium)
                                Text(
                                    "Moist, balanced soil—your Calathea likely happy and thriving! 🌱"
                                )
                                .font(.baseMedium)
                            }
                            .frame(maxWidth: 172)
                        }
                    }
                    .padding(.top, 70)

                    VStack(alignment: .leading) {
                        Text("Nutrients")
                            .font(.h1)

                        VStack {
                            ListItem(titleLeading: "pH", valueTrailing: "\(Int(pH))")
                            Rectangle()
                                .modifier(DashStyle())

                            ListItem(
                                titleLeading: "Nitrogen",
                                valueTrailing: "\(Int(nitrogen))%"
                            )
                            Rectangle()
                                .modifier(DashStyle())
                            ListItem(
                                titleLeading: "Potassium",
                                valueTrailing: "\(Int(potassium))%"
                            )
                            Rectangle()
                                .modifier(DashStyle())
                            ListItem(
                                titleLeading: "Phosphorus",
                                valueTrailing: "\(Int(phosphorus))%"
                            )
                        }
                        .frame(maxWidth: .infinity)

                    }

                    VStack(alignment: .leading) {
                        HStack {
                            Text("Quick Tips")
                                .font(.h1)
                        }

                        VStack {
                            SimpleCard()
                        }
                    }

                }
            }

        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .transition(.slide)
    }
}

struct DashStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 1)
            .foregroundColor(.clear)
            .background(
                Color.clear
                    .frame(height: 1)
                    .overlay(
                        GeometryReader { geo in
                            Path { path in
                                path.move(to: .zero)
                                path.addLine(
                                    to: CGPoint(x: geo.size.width, y: 0)
                                )
                            }
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundColor(.midGreenYellow500)
                        }
                    )
            )
    }
}

//
//#Preview {
//    AnalyzeView()
//}
