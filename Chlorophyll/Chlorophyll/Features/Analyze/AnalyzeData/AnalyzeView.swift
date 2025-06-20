//
//  AnalyzeView.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 19/06/25.
//

import SwiftUI

struct AnalyzeView: View {
    @StateObject var viewModel = AnalyzeDataViewModel()
    @State private var progress: CGFloat = 0.0
    @State private var percentage: Int = 0
    @State private var navigateToResult = false
    @Environment(\.dismiss) var dismiss

    let pH: Double
    let nitrogen: String
    let phosphorus: String
    let potassium: String
    //    let plantHealth : String
    let stressPrediction: String

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 40) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Result")
                                .font(.h1)
                            Spacer()
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "x.circle")
                                    .foregroundStyle(.darkCharcoal300)
                                    .font(.title)
                            }
                        }

                        HStack(spacing: 24) {
                            Image(viewModel.getImage(stress: stressPrediction))
                                .resizable()
                                .frame(width: 125, height: 125)
                            VStack(alignment: .leading, spacing: 8) {
                                Text(stressPrediction)
                                    .font(.custom("Manrope-Bold", size: 14))

                                Text(
                                    viewModel.contentResult(
                                        stress: stressPrediction
                                    )
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
                            ListItem(
                                titleLeading: "pH",
                                valueTrailing: String(format: "%.1f", pH),
                                idealValue: pH >= 5.5 && pH <= 7
                            )
                            Rectangle()
                                .modifier(DashStyle())

                            ListItem(
                                titleLeading: "Nitrogen",
                                valueTrailing: nitrogen,
                                idealValue: nitrogen != "Low"
                            )
                            Rectangle()
                                .modifier(DashStyle())
                            ListItem(
                                titleLeading: "Potassium",
                                valueTrailing: potassium,
                                idealValue: potassium != "Low"
                            )
                            Rectangle()
                                .modifier(DashStyle())
                            ListItem(
                                titleLeading: "Phosphorus",
                                valueTrailing: phosphorus,
                                idealValue: phosphorus != "Low"
                            )
                        }
                        .frame(maxWidth: .infinity)

                    }

                    VStack(alignment: .leading) {
                        HStack {
                            Text("Best Conditions")
                                .font(.h1)
                        }

                        HStack(spacing: 10) {
                            VStack(spacing: 10) {
                                ConditionCard(
                                    imageName: "icon_humidity",
                                    title: "Humidity",
                                    value: "50-70%"
                                )
                                ConditionCard(
                                    imageName: "icon_temperature",
                                    title: "Temperature",
                                    value: "16-30°C"
                                )
                            }

                            VStack(spacing: 10) {
                                ConditionCard(
                                    imageName: "icon_soilph",
                                    title: "soil pH",
                                    value: "5.5-7.0"
                                )
                                ConditionCard(
                                    imageName: "icon_npk",
                                    title: "NPK ratio",
                                    value: "10:10:10"
                                )
                            }

                            Spacer()
                        }.frame(maxWidth: .infinity)
                            .padding(.leading, 4)
                    }

                    VStack(alignment: .leading) {
                        HStack {
                            Text("Quick Tips")
                                .font(.h1)
                        }

                        VStack {
                            SimpleCard()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.leading, 4)
                    }
                    .padding(.bottom, 60)

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
