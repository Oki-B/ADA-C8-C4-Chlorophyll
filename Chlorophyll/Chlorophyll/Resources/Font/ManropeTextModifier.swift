//
//  ManropeTextModifier.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 14/06/25.
//

import SwiftUI

// MARK: enum for text style list
enum ManropeTextStyle {
    // Font lists
    case h1
    case h2
    case h3
    case h4
    case baseMedium
    case baseRegular
    case smallMedium
    case smallRegular
    
    // Font size config
    var size: CGFloat {
        switch self {
        case .h1: return 24
        case .h2: return 20
        case .h3: return 18
        case .h4: return 16
        case .baseMedium, .baseRegular: return 14
        case .smallMedium, .smallRegular: return 12
        }
    }
    
    // Font weight config
    var weight: Font.Weight {
        switch self {
        case .h1, .h2, .h3, .h4: return .medium
        case .baseMedium: return .regular
        case .baseRegular: return .light
        case .smallMedium: return .regular
        case .smallRegular: return .light
        }
    }
}

// MARK: Font Modifier with Manrope
struct ManropeFontModifier: ViewModifier {
    let style: ManropeTextStyle
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Manrope", size: style.size))
            .fontWeight(style.weight)
    }
}

extension Text {
    func font(_ style: ManropeTextStyle) -> some View {
        self.modifier(ManropeFontModifier(style: style))
    }
}

struct ManropeTextModifier: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Text Style Preview")
                .font(.title)
                .bold()
            
            // manrope font preview
            Text("H1 - Hello, World!")
                .font(.h1)
            Text("H2 - Hello, World!")
                .font(.h2)
            Text("H3 - Hello, World!")
                .font(.h3)
            Text("H4 - Hello, World!")
                .font(.h4)
            Text("Base/Medium - Hello, World!")
                .font(.baseMedium)
            Text("Base/Regular - Hello, World!")
                .font(.baseRegular)
            Text("Small/Medium - Hello, World!")
                .font(.smallMedium)
            Text("Small/Regular - Hello, World!")
                .font(.smallRegular)
        }
  
    }
}

#Preview {
    ManropeTextModifier()
}
