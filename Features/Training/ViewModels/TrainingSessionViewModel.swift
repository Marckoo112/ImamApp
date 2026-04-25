//
//  TrainingSessionViewModel.swift
//  ImamApp
//
//  Created by Sande Effendi on 16/04/26.
//

import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
final class TrainingSessionViewModel {
    var sessionState: SessionState = .idle
    var selectedConfig: SessionConfig = .default
    var remainingTime: TimeInterval = 0
    var detectedBody: DetectedBody?
    var jointAngles: [JointAngle] = []
    
    // AI Stroke Recognition
    private let strokeEngine = StrokeCounterEngine()
    var forehandCount: Int { strokeEngine.forehandCount }
    var backhandCount: Int { strokeEngine.backhandCount }
    var coachingTip: String { strokeEngine.coachingTip }
    var isFormValid: Bool { strokeEngine.isFormValid }

    // hasil feedback setelah sesi selesai
    var strokeFeedback: [StrokeFeedback] = []

    // akumulasi angle selama sesi — key = nama joint, value = list riwayat angle
    private var accumulatedAngles: [String: [CGFloat]] = [:]

    private var countdownTimer: Timer?
    private var sessionTimer: Timer?
    private var currentCountdownValue: Int = 5

    // MARK: - Setup

    func selectConfig(_ config: SessionConfig) {
        selectedConfig = config
    }

    // MARK: - State Transitions

    func startSession() {
        sessionState = .idle
        remainingTime = selectedConfig.duration
        accumulatedAngles = [:]
        strokeFeedback = []
        strokeEngine.reset()
    }

    func updateDetectedBody(_ body: DetectedBody?) {
        detectedBody = body

        switch sessionState {
        case .idle:
            if let body = body, body.isComplete {
                transitionToBodyDetected()
            }
        case .bodyDetected, .countdown:
            if let body = body, !body.isComplete {
                resetToIdle()
            }
        case .sessionActive:
            if let body = body {
                jointAngles = JointAngleCalculator.calculateAngles(from: body)
                accumulateAngles(jointAngles)
                
                // Real-time Stroke Analysis
                strokeEngine.processFrame(body: body, strokeType: selectedConfig.trainingType, angles: jointAngles)
            }
        case .sessionEnded:
            break
        }
    }

    // rekam angle tiap frame biar bisa dirata-rata pas selesai
    private func accumulateAngles(_ angles: [JointAngle]) {
        for angle in angles {
            accumulatedAngles[angle.name, default: []].append(angle.degrees)
        }
    }

    private func transitionToBodyDetected() {
        withAnimation(.easeInOut(duration: 0.4)) {
            sessionState = .bodyDetected
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.startCountdown()
        }
    }

    private func startCountdown() {
        currentCountdownValue = 5
        sessionState = .countdown(currentCountdownValue)

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }

            self.currentCountdownValue -= 1

            if self.currentCountdownValue > 0 {
                self.sessionState = .countdown(self.currentCountdownValue)
            } else {
                self.countdownTimer?.invalidate()
                self.countdownTimer = nil
                self.startActiveSession()
            }
        }
    }

    private func startActiveSession() {
        sessionState = .sessionActive
        remainingTime = selectedConfig.duration

        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }

            self.remainingTime -= 1

            if self.remainingTime <= 0 {
                self.endSession()
            }
        }
    }

    private func resetToIdle() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        currentCountdownValue = 5

        withAnimation(.easeInOut(duration: 0.4)) {
            sessionState = .idle
        }
    }

    func stopSession() {
        endSession()
    }

    private func endSession() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        sessionTimer?.invalidate()
        sessionTimer = nil

        // generate feedback dari data yang sudah dikumpulkan
        let feedback = StrokeFeedbackEngine.analyze(
            angles: accumulatedAngles,
            strokeType: selectedConfig.trainingType
        )
        strokeFeedback = feedback

        // simpan summary ke UserDefaults buat ditampilkan di Home
        saveLastFeedbackSummary(from: feedback)

        sessionState = .sessionEnded
    }

    func reset() {
        endSession()
        detectedBody = nil
        jointAngles = []
        accumulatedAngles = [:]
        sessionState = .idle
        strokeEngine.reset()
    }

    // MARK: - Formatting

    var formattedRemainingTime: String {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // MARK: - Persistence

    // simpan tip pertama (yang paling prioritas) ke UserDefaults
    // biar Home bisa munculin overview dari sesi terakhir
    private func saveLastFeedbackSummary(from feedback: [StrokeFeedback]) {
        let totalStrokes = selectedConfig.trainingType == .forehand ? forehandCount : backhandCount
        
        let strokeName = selectedConfig.trainingType == .forehand ? "Forehand" : "Backhand"
        let summary = "\(strokeName): \(totalStrokes) strokes — \(feedback.first?.title ?? "Session Completed")"
        UserDefaults.standard.set(summary, forKey: "lastFeedbackSummary")

        // simpan juga 2-3 item feedback sebagai JSON string sederhana
        let titles = feedback.prefix(3).map { "\($0.title): \($0.detail)" }
        if let data = try? JSONEncoder().encode(titles) {
            UserDefaults.standard.set(data, forKey: "lastFeedbackItems")
        }

        UserDefaults.standard.set(strokeName, forKey: "lastStrokeName")
        UserDefaults.standard.set(Date(), forKey: "lastSessionDate")
        UserDefaults.standard.set(totalStrokes, forKey: "lastSessionStrokes")
    }
}
