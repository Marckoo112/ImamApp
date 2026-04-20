//
//  ResuktVie.swift
//  ImamApp
//
//  Created by Imam on 18/04/26.
//

import SwiftUI

struct ResultView: View {
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // TITLE
                Text("Result")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // SUMMARY CARD
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Session Result")
                            .font(.headline)
                        
                        Text("Here's your latest training performance")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(20)
            
                
                Text("Feedback")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 12) {
                    FeedbackRow(text: "- Elbow too wide — reduce by ~15°")
                    FeedbackRow(text: "- Follow-through not consistent")
                    FeedbackRow(text: "- Improve contact timing")
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.red.opacity(0.1))
                .cornerRadius(20)
                
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    ResultView()
}

func FeedbackRow(text: String) -> some View {
        HStack {
            Text(text)
                .font(.subheadline)
                .foregroundColor(.red)
        }
    }
