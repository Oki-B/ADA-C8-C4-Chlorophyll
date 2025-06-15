//
//  ConfirmColorViewModel.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 16/06/25.
//

import SwiftUI
import UIKit
import CoreML

class ConfirmColorViewModel: ObservableObject {
    @Published var pH: Double? = nil
    @Published var selectedColor: Color = .clear
    @Published var dragLocation: CGPoint = .zero
    @Published var isManualMode: Bool = false
    @Published var redInt: Int = 0
    @Published var greenInt: Int = 0
    @Published var blueInt: Int = 0

    var uiImage: UIImage = UIImage(named: "soil-sample")!

    func updateColorAndRGB(from location: CGPoint, in frameSize: CGSize) {
        guard let cgImage = uiImage.cgImage else { return }

        let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
        let imageAspect = imageSize.width / imageSize.height
        let frameAspect = frameSize.width / frameSize.height

        var displayedSize = CGSize.zero
        var imageOrigin = CGPoint.zero

        if imageAspect > frameAspect {
            displayedSize.height = frameSize.height
            displayedSize.width = frameSize.height * imageAspect
            imageOrigin.x = (frameSize.width - displayedSize.width) / 2
        } else {
            displayedSize.width = frameSize.width
            displayedSize.height = frameSize.width / imageAspect
            imageOrigin.y = (frameSize.height - displayedSize.height) / 2
        }

        let relX = (location.x - imageOrigin.x) / displayedSize.width
        let relY = (location.y - imageOrigin.y) / displayedSize.height

        guard (0...1).contains(relX), (0...1).contains(relY) else { return }

        let pixelX = Int(relX * imageSize.width)
        let pixelY = Int(relY * imageSize.height)

        let rawData = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        defer { rawData.deallocate() }

        let context = CGContext(
            data: rawData,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )

        context?.draw(
            cgImage,
            in: CGRect(
                x: -CGFloat(pixelX),
                y: -CGFloat(pixelY),
                width: imageSize.width,
                height: imageSize.height
            )
        )

        redInt = Int(rawData[0])
        greenInt = Int(rawData[1])
        blueInt = Int(rawData[2])
        selectedColor = Color(
            red: Double(redInt) / 255.0,
            green: Double(greenInt) / 255.0,
            blue: Double(blueInt) / 255.0
        )
    }

    func getAverageColorInCenterRegion(regionSize: CGFloat = 150) {
        guard let cgImage = uiImage.cgImage else { return }

        let width = cgImage.width
        let height = cgImage.height

        let startX = max(Int((CGFloat(width) - regionSize) / 2), 0)
        let startY = max(Int((CGFloat(height) - regionSize) / 2), 0)
        let regionWidth = Int(min(regionSize, CGFloat(width) - CGFloat(startX)))
        let regionHeight = Int(min(regionSize, CGFloat(height) - CGFloat(startY)))

        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * regionWidth
        let totalBytes = regionHeight * bytesPerRow

        let rawData = UnsafeMutablePointer<UInt8>.allocate(capacity: totalBytes)
        defer { rawData.deallocate() }

        guard let context = CGContext(
            data: rawData,
            width: regionWidth,
            height: regionHeight,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return
        }

        context.draw(
            cgImage,
            in: CGRect(x: -startX, y: -startY, width: width, height: height)
        )

        var totalR = 0
        var totalG = 0
        var totalB = 0
        let pixelCount = regionWidth * regionHeight

        for i in 0..<pixelCount {
            let offset = i * bytesPerPixel
            totalR += Int(rawData[offset])
            totalG += Int(rawData[offset + 1])
            totalB += Int(rawData[offset + 2])
        }

        let avgR = totalR / pixelCount
        let avgG = totalG / pixelCount
        let avgB = totalB / pixelCount

        redInt = avgR
        greenInt = avgG
        blueInt = avgB
        selectedColor = Color(
            red: Double(avgR) / 255.0,
            green: Double(avgG) / 255.0,
            blue: Double(avgB) / 255.0
        )
    }
    
    func calculatePH() {
        do {
            let config = MLModelConfiguration()
            let model = try CalatheaProjectPh200(configuration: config)
            
            let prediction = try model.prediction(R: Int64(redInt), G: Int64(greenInt), B: Int64(blueInt))
            
            pH = Double(prediction.pH)
            
        } catch {
            // error
            print(error.localizedDescription)
        }

    }
}

