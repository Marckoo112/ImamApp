//
//  StrokePickerSheet.swift
//  ImamApp
//
//  Created by Imam on 19/04/26.
//

import SwiftUI

struct StrokePickerSheet: View {
    
    @Binding var selectedStroke: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Choose Stroke")
                .font(.headline)
            
            Button("Backhand") {
                selectedStroke = "Back Hand"
                dismiss()
            }
            
            Button("Forehand") {
                selectedStroke = "Fore Hand"
                dismiss()
            }
            
            Spacer()
        }
        .padding()
    }
}
