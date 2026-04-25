//
//  SessionState.swift
//  PoonaApp
//

import Foundation

enum SessionState: Equatable {
    case idle
    case bodyDetected
    case countdown(Int)
    case sessionActive
    case sessionEnded
}
