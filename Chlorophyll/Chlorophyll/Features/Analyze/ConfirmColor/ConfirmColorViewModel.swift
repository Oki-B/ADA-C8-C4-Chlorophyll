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
    
    // for model
    @Published var pH: Double? = nil
    @Published var redInt: Int = 0
    @Published var greenInt: Int = 0
    @Published var blueInt: Int = 0
    @Published var hsv: (h: Int, s: Int, v: Int) = (0, 0, 0)
    
    // view control
    @Published var navigateToNextView: Bool = false
    @Published var selectedColor: Color = .clear
    @Published var dragLocation: CGPoint = .zero
    @Published var isManualMode: Bool = false
    
    // passing data
    @Published var normalPhoto: UIImage?
    @Published var constantColorImage: UIImage?
    
    var uiImage: UIImage {
        if let normalPhoto = normalPhoto {
            return normalPhoto
        } else if let constantColorImage = constantColorImage {
            return constantColorImage
        } else {
            return UIImage(named: "soil-sample")!
        }
    }
    
    
    init(normalPhoto: UIImage? = nil, constantColorImage: UIImage? = nil) {
        self.normalPhoto = normalPhoto
        self.constantColorImage = constantColorImage
    }

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
        
        hsv = rgbToHSV(r: redInt, g: greenInt, b: blueInt)
        
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
    
    func getDominantColorInCenterRegion(regionSize: CGFloat = 100, binSize: Int = 10) {
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

        var colorFrequency: [UInt32: Int] = [:]
        let pixelCount = regionWidth * regionHeight

        for i in 0..<pixelCount {
            let offset = i * bytesPerPixel

            // Ambil RGB dan lakukan binning
            let r = (Int(rawData[offset]) / binSize) * binSize
            let g = (Int(rawData[offset + 1]) / binSize) * binSize
            let b = (Int(rawData[offset + 2]) / binSize) * binSize

            let colorKey = (UInt32(r) << 16) | (UInt32(g) << 8) | UInt32(b)
            colorFrequency[colorKey, default: 0] += 1
        }

        if let (dominantKey, _) = colorFrequency.max(by: { $0.value < $1.value }) {
            let r = Int((dominantKey >> 16) & 0xFF)
            let g = Int((dominantKey >> 8) & 0xFF)
            let b = Int(dominantKey & 0xFF)

            redInt = r
            greenInt = g
            blueInt = b
            
            hsv = rgbToHSV(r: r, g: g, b: b)

            selectedColor = Color(
                red: Double(r) / 255.0,
                green: Double(g) / 255.0,
                blue: Double(b) / 255.0
            )
        }
    }
    
    
    func rgbToHSV(r: Int, g: Int, b: Int) -> (h: Int, s: Int, v: Int) {
        let rf = Double(r)/255.0
        let gf = Double(g)/255.0
        let bf = Double(b)/255.0
        let maxVal = max(rf, gf, bf)
        let minVal = min(rf, gf, bf)
        let delta = maxVal - minVal

        // Hue calculation
        var h: Double = 0
        if delta == 0 {
            h = 0
        } else if maxVal == rf {
            h = 60 * (((gf - bf)/delta).truncatingRemainder(dividingBy: 6))
        } else if maxVal == gf {
            h = 60 * (((bf - rf)/delta) + 2)
        } else if maxVal == bf {
            h = 60 * (((rf - gf)/delta) + 4)
        }
        if h < 0 { h += 360 }

        // Saturation calculation
        let s: Double = maxVal == 0 ? 0 : (delta / maxVal)
        // Value calculation
        let v: Double = maxVal

        return (h: Int(round(h)), s: Int(round(s * 100)), v: Int(round(v * 100)))
    }

    
    func calculatePH() {
        do {
            let config = MLModelConfiguration()
            let model = try SoilpHRegressor(configuration: config)
            
            let prediction = try model.prediction(R: Double(redInt)/255, G: Double(greenInt)/255, B: Double(blueInt)/255, H: Double(hsv.h)/255, S: Double(hsv.s)/255, V: Double(hsv.v)/255 )
            
            pH = prediction.pH_target
            
        } catch {
            // error
            print(error.localizedDescription)
        }

    }
}

