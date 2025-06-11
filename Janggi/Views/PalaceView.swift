import SwiftUI

struct PalaceView: View {
    let squareSize: CGFloat
    
    var body: some View {
        Path { path in
            // Red palace
            path.move(to: CGPoint(x: squareSize * 3, y: squareSize * 0))
            path.addLine(to: CGPoint(x: squareSize * 5, y: squareSize * 2))
            path.move(to: CGPoint(x: squareSize * 5, y: squareSize * 0))
            path.addLine(to: CGPoint(x: squareSize * 3, y: squareSize * 2))
            
            // Blue palace
            path.move(to: CGPoint(x: squareSize * 3, y: squareSize * 7))
            path.addLine(to: CGPoint(x: squareSize * 5, y: squareSize * 9))
            path.move(to: CGPoint(x: squareSize * 5, y: squareSize * 7))
            path.addLine(to: CGPoint(x: squareSize * 3, y: squareSize * 9))
        }
        .stroke(Color.black, lineWidth: 1)
    }
}

#Preview {
    ZStack {
        Rectangle()
            .fill(Color(red: 0.8, green: 0.7, blue: 0.5))
            .frame(width: 360, height: 400)
        
        PalaceView(squareSize: 40)
    }
    .padding()
} 