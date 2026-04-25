//
//  StrokeCounterEngine.swift
//  ImamApp
//
//  Created by Antigravity on 23/04/26.
//

import Foundation
import CoreGraphics
import Observation

@Observable
final class StrokeCounterEngine {
    enum SwingPhase {
        case idle
        case preparation
        case contact
        case followThrough
    }
    
    var forehandCount: Int = 0
    var backhandCount: Int = 0
    var currentPhase: SwingPhase = .idle
    var coachingTip: String = "Ready to start!"
    var isFormValid: Bool = true
    
    private var handDominance: String = "Right Hand"
    private var lastPhaseUpdate = Date()
    
    init() {
        self.handDominance = UserDefaults.standard.string(forKey: "selectedHand") ?? "Right Hand"
    }
    
    func reset() {
        forehandCount = 0
        backhandCount = 0
        currentPhase = .idle
        coachingTip = "Ready to start!"
        isFormValid = true
    }
    
    func processFrame(body: DetectedBody, strokeType: TrainingModule.TrainingType, angles: [JointAngle]) {
        guard body.isComplete else { return }
        
        let dominantWrist: BodyJoint = (handDominance == "Right Hand") ? .rightWrist : .leftWrist
        let dominantShoulder: BodyJoint = (handDominance == "Right Hand") ? .rightShoulder : .leftShoulder
        let dominantElbow: BodyJoint = (handDominance == "Right Hand") ? .rightElbow : .leftElbow
        
        guard let wrist = body.joints[dominantWrist],
              let shoulder = body.joints[dominantShoulder],
              let elbow = body.joints[dominantElbow] else { return }
        
        let deltaX = wrist.location.x - shoulder.location.x
        let now = Date()
        
        // State Machine logic
        switch currentPhase {
        case .idle:
            if strokeType == .forehand {
                // Forehand preparation: Hand moves outwards (Right hand → negative X delta in mirrored view)
                let threshold: CGFloat = (handDominance == "Right Hand") ? -40 : 40
                if (handDominance == "Right Hand" && deltaX < threshold) || (handDominance == "Left Hand" && deltaX > threshold) {
                    updatePhase(.preparation, tip: "Swing coming!")
                }
            } else if strokeType == .backhand {
                // Backhand preparation: Hand moves across chest (Right hand → positive X delta in mirrored view)
                let threshold: CGFloat = (handDominance == "Right Hand") ? 40 : -40
                if (handDominance == "Right Hand" && deltaX > threshold) || (handDominance == "Left Hand" && deltaX < threshold) {
                    updatePhase(.preparation, tip: "Get ready!")
                }
            }
            
        case .preparation:
            // Contact: hand moving back to center/front
            if abs(deltaX) < 30 {
                updatePhase(.contact, tip: "Contact!")
                
                // Form feedback: Check shoulder/elbow height
                let elbowY = elbow.location.y
                let shoulderY = shoulder.location.y
                
                if elbowY > shoulderY + 20 {
                    coachingTip = "Raise your elbow!"
                    isFormValid = false
                } else {
                    coachingTip = "Nice hit!"
                    isFormValid = true
                }
            }
            
        case .contact:
            // Follow-through: Hand finishes on the opposite side
            let threshold: CGFloat = (handDominance == "Right Hand") ? 60 : -60
            if (strokeType == .forehand && ((handDominance == "Right Hand" && deltaX > threshold) || (handDominance == "Left Hand" && deltaX < threshold))) ||
               (strokeType == .backhand && ((handDominance == "Right Hand" && deltaX < -threshold) || (handDominance == "Left Hand" && deltaX > threshold))) {
                
                if strokeType == .forehand {
                    forehandCount += 1
                } else {
                    backhandCount += 1
                }
                updatePhase(.followThrough, tip: "Perfect!")
            }
            
        case .followThrough:
            // Return to neutral to restart
            if abs(deltaX) < 20 && now.timeIntervalSince(lastPhaseUpdate) > 0.5 {
                updatePhase(.idle, tip: "Go again!")
            }
        }
    }
    
    private func updatePhase(_ phase: SwingPhase, tip: String) {
        currentPhase = phase
        coachingTip = tip
        lastPhaseUpdate = Date()
    }
}
