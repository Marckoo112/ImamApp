//
//  JointAngle.swift
//  PoonaApp
//

import CoreGraphics
import Foundation

struct JointAngle: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let degrees: CGFloat
    let jointPosition: CGPoint
}
