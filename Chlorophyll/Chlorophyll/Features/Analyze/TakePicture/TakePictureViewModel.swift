//
//  TakePictureViewModel.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 15/06/25.
//

import Foundation
import AVFoundation
import SwiftUI
import CoreImage
import UIKit


// View model for camera use

class TakePictureViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    // create session for photo
    private let session = AVCaptureSession()
    
    private var photoOutput: AVCapturePhotoOutput?
    private var sessionQueue: DispatchQueue = DispatchQueue(label: "sessionQueue")
    
    // variable to enable set-up
    var constantColorEnable: Bool = true
    var flashEnable: Bool = true
    
    var constantColorSupported: Bool = false
    
}
