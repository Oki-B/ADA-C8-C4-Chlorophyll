//
//  ViewFinderView.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 15/06/25.
//

import SwiftUI

struct ViewFinderView: View {
    @Binding var image: Image?
    
    var body: some View {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
            }
    }
}
