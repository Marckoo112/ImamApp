import SwiftUI

struct HandPickerSheet: View {
    
    @Binding var selectedHand: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Choose Hand")
                .font(.headline)
            
            Button("Left Hand") {
                selectedHand = "Left Hand"
                dismiss()
            }
            
            Button("Right Hand") {
                selectedHand = "Right Hand"
                dismiss()
            }
            
            Spacer()
        }
        .padding()
    }
}
