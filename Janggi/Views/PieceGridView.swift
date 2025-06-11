import SwiftUI

struct PieceGridView: View {
    @ObservedObject var board: Board
    let squareSize: CGFloat
    let onSquareTap: (Position) -> Void
    
    var body: some View {
        ForEach(0..<10) { row in
            ForEach(0..<9) { col in
                if let piece = board.pieces[row][col] {
                    PieceView(piece: piece)
                        .position(
                            x: CGFloat(col) * squareSize + squareSize/2,
                            y: CGFloat(row) * squareSize + squareSize/2
                        )
                        .onTapGesture {
                            onSquareTap(Position(row: row, col: col))
                        }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Rectangle()
            .fill(Color(red: 0.8, green: 0.7, blue: 0.5))
            .frame(width: 360, height: 400)
        
        PieceGridView(
            board: Board(),
            squareSize: 40,
            onSquareTap: { _ in }
        )
    }
    .padding()
} 