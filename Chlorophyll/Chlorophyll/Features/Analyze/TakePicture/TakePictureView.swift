//
//  TakePictureView.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 15/06/25.
//

import Photos
import SwiftUI

struct TakePictureView: View {
    // The data model object.
    @State private var model = DataModel()

    @State private var instructionShow: Bool = false

    // A Boolean value that indicates whether constant color is enabled.
    @State private var constantColorEnabled = false

    // A Boolean value that indicates whether flash is enabled.
    @State private var flashEnabled = false

    // A Boolean value that indicates whether the user attempted to capture a constant color photo with flash capture disabled.
    @State private var showFlashError = false

    // A environment value to indicate scene phase changes.
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                if AVCaptureDevice.authorizationStatus(for: .video)
                    != .authorized
                {
                    VStack {
                        Spacer()
                        StepBar(currentStep: 1)
                        Spacer()
                        Text(
                            "You haven't authorized ConstantColorCam to use the camera. Change these settings in Settings -> Privacy & Security."
                        )
                        Image(
                            systemName:
                                "lock.trianglebadge.exclamationmark.fill"
                        )
                        .resizable()
                        .symbolRenderingMode(.multicolor)
                        .aspectRatio(contentMode: .fit)

                        Spacer()
                        Spacer()
                    }
                    .padding()

                } else {
                    GeometryReader { geometry in
                        ZStack {
                            ViewFinderView(image: $model.viewfinderImage)
                                .frame(
                                    width: geometry.size.width,
                                    height: geometry.size.height
                                )

                            Circle()
                                .stroke(
                                    style: StrokeStyle(
                                        lineWidth: 2,
                                        dash: [16]
                                    )
                                )
                                .foregroundStyle(Color.green)
                                .frame(width: 240, height: 240)
                                .position(
                                    x: geometry.size.width / 2,
                                    y: geometry.size.height / 2
                                )

                            VStack(spacing: 0) {
                                StepBar(currentStep: 1)
                                    .padding(.top, 30)

                                Spacer()
                                
                                bottomBarView
                                    .navigationDestination(
                                        isPresented: $model.camera
                                            .photosViewVisible,
                                        destination: {
                                            ConfirmColorView(viewModel: ConfirmColorViewModel(
                                                normalPhoto: model.camera
                                                    .normalPhoto,
                                                constantColorImage: model.camera
                                                    .constantColorPhoto
                                                )
                                            )
                                        }
                                    )
                                    .alert(
                                        "Photo Capture Error!",
                                        isPresented: $showFlashError
                                    ) {
                                        Button("OK") {}
                                    } message: {
                                        Text(
                                            "The constant color algorithm requires flash. Please make sure to set flashMode to .on or .auto."
                                        )
                                    }
                                    .padding(.bottom, 30)
                                
                            }
                        }
                    }

                }
            }
            .task {
                await model.camera.start()
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    Task {
                        await model.camera.checkCameraAuthorization()
                    }
                }
            }
            .onAppear { instructionShow = true }
            .onDisappear {
                model.camera.stop()
            }
            .navigationBarHidden(true)
            .statusBar(hidden: true)
            .sheet(isPresented: $instructionShow) {
                TakePictureInstructionView().presentationDetents([.height(700)])
            }
            .preferredColorScheme(instructionShow ? .light : .dark)

        }
    }

    var bottomBarView: some View {
        ZStack(alignment: .center) {
            HStack {
                // Kiri: Tombol Tutorial
                Button("Tutorial", action: { dismiss() })
                    .foregroundColor(.white)
                    .padding(.leading, 15)

                Spacer()

                // Kanan: Toggle flash dan constant color
                VStack(alignment: .trailing, spacing: 8) {
                    if model.camera.constantColorSupported {
                        CameraOptionToggle(
                            textLabel: "CC",
                            toggleValue: $constantColorEnabled
                        )
                    }

                    CameraOptionToggle(
                        textLabel: "Flash",
                        toggleValue: $flashEnabled
                    )
                }
            }
            .padding(.horizontal, 6)
            .padding(.bottom, 30)

            // Tombol shutter benar-benar center
            ZStack {
                ShutterButton(action: takePhoto)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 30)
            .disabled(!model.camera.shutterButtonAvailable)
        }

    }

    private func takePhoto() {
        if constantColorEnabled && (flashEnabled == false) {
            // Show an error if the user attempts to capture a constant color photo with flash capture disabled.
            self.showFlashError = true
        } else {
            // Update the camera's settings, and capture the photo.
            model.camera.constantColorEnabled = constantColorEnabled
            model.camera.flashEnabled = flashEnabled
            model.camera.takePhoto()
        }
    }
}


#Preview {
    TakePictureView()
}
