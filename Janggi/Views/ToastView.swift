import SwiftUI

struct ToastView: View {
    let message: String
    let show: Bool
    
    var body: some View {
        if show {
            HStack {
                Spacer()
                Text(message)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue)
                            .shadow(radius: 8, y: 4)
                    )
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        )
                    )
                    .padding(.top, 40)
                    .padding(.trailing, 24)
            }
            .zIndex(100)
        }
    }
}

#Preview {
    ToastView(message: "Test message!", show: true)
} 