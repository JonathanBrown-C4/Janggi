import SwiftUI

struct BoardGridView: View {
    @ObservedObject var board: Board
    let squareSize: CGFloat
    let onSquareTap: (Position) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<10) { row in
                HStack(spacing: 0) {
                    ForEach(0..<9) { col in
                        let position = Position(row: row, col: col)
                        SquareView(
                            position: position,
                            squareSize: squareSize,
                            isSelected: board.selectedPiece == position,
                            isValidMove: board.validMoves.contains(where: { $0.row == row && $0.col == col }),
                            onTap: { onSquareTap(position) }
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    BoardGridView(
        board: Board(),
        squareSize: 40,
        onSquareTap: { _ in }
    )
    .padding()
} 