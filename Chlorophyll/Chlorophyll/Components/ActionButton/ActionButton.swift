//
//  ActionButton.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 14/06/25.
//

import SwiftUI

enum ActionButtonTitle {
    case start
    case begin
    case takePicture
    case next
    case submit
    case save
    
    var title: String {
        switch self {
        case .start:
            return "Start"
        case .begin:
            return "Let's Begin"
        case .takePicture:
            return "Capture Soil Image"
        case .next:
            return "Next"
        case .submit:
            return "Submit"
        case .save:
            return "Save"
        }
    }
}

struct ActionButton: View {
    let title: ActionButtonTitle
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title.title)
                .font(.baseMedium)
                .modifier(ActionButtonLabelTextStyle())
        }
    }
}


#Preview {
    ActionButton(title: .takePicture, action: {})
}
