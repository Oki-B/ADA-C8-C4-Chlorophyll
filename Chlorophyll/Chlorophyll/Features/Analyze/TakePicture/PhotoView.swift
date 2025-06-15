//
//  PhotoView.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 15/06/25.
//

import Photos
import SwiftUI

struct PhotoView: View {
    // The constant color UIImage.
    private var constantColorImage: UIImage?
    
    // The normal photo UIImage.
    private var normalPhoto: UIImage?
    
    // The selection integer for the tab view.
    @State private var selection: Int = 0
    
    // The environment variable to dismiss the photos tab view.
    @Environment(\.dismiss) private var dismiss
    
    // The view initializer for the photos tab view.
    init(normalPhoto: UIImage? = nil, constantColorImage: UIImage? = nil) {
        self.constantColorImage = constantColorImage
        self.normalPhoto = normalPhoto
    }
    
    var body: some View {
        HStack {
            Spacer()
            // The Done button to dismiss the photos tab view.
            Button() {
                dismiss()
            } label: {
                Text("Done").foregroundStyle(.blue)
            }.padding(.trailing, 15)
        }
        NavigationStack {
            if let normalPhoto = normalPhoto {
                // The normal photo tab view.
                TabView(selection: $selection) {
                    ImageView(image: normalPhoto, textLabel: "Normal Photo")
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            } else if let constantColorImage = constantColorImage {
                // The constant color image, fallback photo, and confidence map tab view.
                TabView(selection: $selection) {
                    ImageView(image: constantColorImage, textLabel: "Constant Color Photo")
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            }
        }
    }
    
}

// The image view for the photos tab view.
struct ImageView: View {
    private var image: UIImage?
    private var text: String
        
    // The initializer for the image view.
    init(image: UIImage?, textLabel: String) {
        self.image = image
        self.text = textLabel
    }
    
    var body: some View {
        VStack {
            if let image {
                // The image and text views for the constant color photo, fallback photo, and normal photo.
                Text(text).padding(.bottom, 40).foregroundColor(.white)
                ZStack {
                    Text("test")
                        .foregroundStyle(.white)
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(15)
                        .padding(.bottom, 50)
                }

            }
        }
        .background(.black)
    }
}

#Preview {
    PhotoView(normalPhoto: UIImage(systemName: "exclamationmark.circle.fill"))
}


