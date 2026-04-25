//
//  JointsOverlayView.swift
//  PoonaApp
//
//  Created by Sande Effendi on 16/04/26.
//

import SwiftUI

struct JointsOverlayView: View {
    let detectedBody: DetectedBody?
    let jointAngles: [JointAngle]
    var isFormValid: Bool = true

    private let connections: [(BodyJoint, BodyJoint)] = [
        (.nose, .leftEye), (.nose, .rightEye),
        (.leftEye, .leftEar), (.rightEye, .rightEar),
        (.nose, .leftShoulder), (.nose, .rightShoulder),
        (.leftShoulder, .leftElbow), (.rightShoulder, .rightElbow),
        (.leftElbow, .leftWrist), (.rightElbow, .rightWrist),
        (.leftShoulder, .leftHip), (.rightShoulder, .rightHip),
        (.leftHip, .leftKnee), (.rightHip, .rightKnee),
        (.leftKnee, .leftAnkle), (.rightKnee, .rightAnkle),
    ]

    var body: some View {
        Canvas { context, size in
            guard let body = detectedBody, body.isComplete else { return }
            
            let strokeColor: Color = isFormValid ? .green : .red

            // Draw connections
            for (fromJoint, toJoint) in connections {
                guard let fromPoint = body.joints[fromJoint]?.location,
                      let toPoint = body.joints[toJoint]?.location else { continue }

                var path = Path()
                path.move(to: fromPoint)
                path.addLine(to: toPoint)

                context.stroke(
                    path,
                    with: .color(strokeColor.opacity(0.8)),
                    lineWidth: 4
                )
            }

            // Draw joint dots
            for (_, joint) in body.joints {
                let rect = CGRect(
                    x: joint.location.x - 6,
                    y: joint.location.y - 6,
                    width: 12,
                    height: 12
                )
                let circlePath = Path(ellipseIn: rect)

                context.fill(circlePath, with: .color(.white))
                context.stroke(circlePath, with: .color(strokeColor), lineWidth: 2)
            }

            // Draw angle labels
            for angle in jointAngles {
                let text = Text("\(Int(angle.degrees))°")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)

                let resolved = context.resolve(text)
                let textSize = resolved.measure(in: size)

                let bgRect = CGRect(
                    x: angle.jointPosition.x + 8,
                    y: angle.jointPosition.y - textSize.height - 8,
                    width: textSize.width + 12,
                    height: textSize.height + 8
                )

                context.fill(
                    Path(roundedRect: bgRect, cornerRadius: 6),
                    with: .color(.black.opacity(0.7))
                )

                context.draw(
                    text,
                    at: CGPoint(
                        x: angle.jointPosition.x + 8 + textSize.width / 2 + 6,
                        y: angle.jointPosition.y - textSize.height / 2 - 4
                    )
                )
            }
        }
    }
}

#Preview {
    JointsOverlayView(detectedBody: nil, jointAngles: [])
}
