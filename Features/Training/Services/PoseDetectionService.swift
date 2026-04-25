//
//  PoseDetectionService.swift
//  PoonaApp
//

import AVFoundation
import CoreGraphics
import Foundation
import Observation
import Vision

@MainActor
@Observable
final class PoseDetectionState {
    var detectedBody: DetectedBody?
}

final class PoseDetectionService: NSObject, @unchecked Sendable {
    private let state: PoseDetectionState
    private let visionQueue = DispatchQueue(label: "com.poonaapp.vision")
    private let poseRequest = VNDetectHumanBodyPoseRequest()

    init(state: PoseDetectionState) {
        self.state = state
        super.init()
    }

    func processFrame(_ sampleBuffer: CMSampleBuffer, previewSize: CGSize) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let bufferWidth = CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let bufferHeight = CGFloat(CVPixelBufferGetHeight(pixelBuffer))

        // For front camera in portrait, the buffer is rotated 90 degrees
        let portraitWidth = bufferHeight
        let portraitHeight = bufferWidth

        visionQueue.async { [weak self] in
            guard let self else { return }

            let imageRequestHandler = VNImageRequestHandler(
                cvPixelBuffer: pixelBuffer,
                orientation: .right,
                options: [:]
            )

            do {
                try imageRequestHandler.perform([self.poseRequest])

                guard let observation = self.poseRequest.results?.first as? VNHumanBodyPoseObservation else {
                    Task { @MainActor in
                        self.state.detectedBody = nil
                    }
                    return
                }

                let detectedBody = self.extractBody(
                    from: observation,
                    portraitWidth: portraitWidth,
                    portraitHeight: portraitHeight,
                    previewSize: previewSize
                )

                Task { @MainActor in
                    self.state.detectedBody = detectedBody
                }
            } catch {
                Task { @MainActor in
                    self.state.detectedBody = nil
                }
            }
        }
    }

    private func extractBody(
        from observation: VNHumanBodyPoseObservation,
        portraitWidth: CGFloat,
        portraitHeight: CGFloat,
        previewSize: CGSize
    ) -> DetectedBody {
        var joints: [BodyJoint: DetectedBody.Joint] = [:]

        for jointName in BodyJoint.allCases {
            guard jointName != .root else { continue }
            do {
                let point = try observation.recognizedPoint(jointName.visionJointName)
                if point.confidence > 0.2 {
                    // Flip X for front-facing camera mirror effect
                    // Flip Y because Vision origin is bottom-left, SwiftUI origin is top-left
                    let normalizedX = 1.0 - point.location.x
                    let normalizedY = 1.0 - point.location.y

                    // Scale to pixel buffer dimensions
                    let pixelX = normalizedX * portraitWidth
                    let pixelY = normalizedY * portraitHeight

                    // Apply aspect-fill scaling to match preview
                    let scaleX = previewSize.width / portraitWidth
                    let scaleY = previewSize.height / portraitHeight
                    let scale = max(scaleX, scaleY)

                    let offsetX = (previewSize.width - portraitWidth * scale) / 2
                    let offsetY = (previewSize.height - portraitHeight * scale) / 2

                    let viewX = pixelX * scale + offsetX
                    let viewY = pixelY * scale + offsetY

                    let viewPoint = CGPoint(x: viewX, y: viewY)

                    joints[jointName] = DetectedBody.Joint(
                        location: viewPoint,
                        confidence: CGFloat(point.confidence)
                    )
                }
            } catch {
                continue
            }
        }

        return DetectedBody(joints: joints)
    }
}
