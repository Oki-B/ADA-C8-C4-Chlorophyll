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
                                .edgesIgnoringSafeArea(.all)

                            VStack(spacing: 0) {
                                StepBar(currentStep: 1)
                                    .padding(.top, 10)
                                Spacer()
                            }
                            Circle()
                                .stroke(
                                    style: StrokeStyle(
                                        lineWidth: 3,
                                        dash: [6]
                                    )
                                )
                                .stroke(Color.green, lineWidth: 3)
                                .frame(width: 200, height: 200)
                                .position(
                                    x: geometry.size.width / 2,
                                    y: geometry.size.height / 2 - 50
                                )

                            VStack {
                                Spacer()
                                bottomBarView
                                    .navigationDestination(
                                        isPresented: $model.camera
                                            .photosViewVisible,
                                        destination: {
                                            ConfirmColorView(
                                                normalPhoto: model.camera
                                                    .normalPhoto,
                                                constantColorImage: model.camera
                                                    .constantColorPhoto
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
            .navigationBarHidden(true)
            .statusBar(hidden: true)
            .ignoresSafeArea()
            .sheet(isPresented: $instructionShow) {
                TakePictureInstructionView()
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
                .padding(.leading, 20)

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
            .padding(.horizontal, 20)
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

struct ShutterButton: View {
    private let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            Label {
                Text("Take Photo")
            } icon: {
                ZStack {
                    Circle()
                        .strokeBorder(.white, lineWidth: !isEnabled ? 3 : 1)
                        .frame(
                            width: !isEnabled ? 65 : 62,
                            height: !isEnabled ? 65 : 62
                        )
                        .animation(
                            .interpolatingSpring(
                                mass: 2.0,
                                stiffness: 100.0,
                                damping: 10,
                                initialVelocity: 0
                            ),
                            value: !isEnabled
                        )
                    Circle()
                        .fill(.white)
                        .frame(
                            width: !isEnabled ? 55 : 50,
                            height: !isEnabled ? 55 : 50
                        )
                        .animation(
                            .interpolatingSpring(
                                mass: 2.0,
                                stiffness: 100.0,
                                damping: 10,
                                initialVelocity: 0
                            ),
                            value: !isEnabled
                        )
                }
            }
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
    }
}

struct CameraOptionToggle: View {
    private let textLabel: String
    @Binding private var toggleValue: Bool

    init(textLabel: String, toggleValue: Binding<Bool>) {
        self.textLabel = textLabel
        self._toggleValue = toggleValue
    }

    var body: some View {
        HStack {
            Text(textLabel).font(.caption).padding(.trailing, 4)
                .foregroundColor(.white)
            Toggle("", isOn: $toggleValue).fixedSize().labelsHidden()
        }
    }
}

#Preview {
    TakePictureView()
}
