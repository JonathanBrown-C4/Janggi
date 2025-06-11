import SwiftUI

struct SquareView: View {
    let position: Position
    let squareSize: CGFloat
    let isSelected: Bool
    let isValidMove: Bool
    let onTap: () -> Void
    
    var body: some View {
        Rectangle()
            .stroke(Color.black, lineWidth: 1)
            .frame(width: squareSize, height: squareSize)
            .background(
                Group {
                    if isSelected {
                        Color.yellow.opacity(0.3)
                    } else if isValidMove {
                        Color.green.opacity(0.3)
                    }
                }
            )
            .onTapGesture(perform: onTap)
    }
}

#Preview {
    VStack(spacing: 20) {
        SquareView(
            position: Position(row: 0, col: 0),
            squareSize: 40,
            isSelected: true,
            isValidMove: false,
            onTap: {}
        )
        
        SquareView(
            position: Position(row: 0, col: 1),
            squareSize: 40,
            isSelected: false,
            isValidMove: true,
            onTap: {}
        )
        
        SquareView(
            position: Position(row: 0, col: 2),
            squareSize: 40,
            isSelected: false,
            isValidMove: false,
            onTap: {}
        )
    }
    .padding()
} 