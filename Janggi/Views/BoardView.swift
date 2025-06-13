import SwiftUI

struct BoardView: View {
    @ObservedObject var board: Board
    let squareSize: CGFloat
    
    var body: some View {
        GeometryReader { geo in
            let columns = 8
            let rows = 9
            let width = geo.size.width
            let height = geo.size.height
            let cellWidth = width / CGFloat(columns)
            let cellHeight = height / CGFloat(rows)
            ZStack {
                // Board background
                Color(red: 0.8, green: 0.7, blue: 0.5)
                // Grid, star points, and pieces
                BoardGridView(board: board, squareSize: cellWidth, onSquareTap: handleSquareTap)
                // Top palace: center at (1,4) in grid lines
                PalaceView(size: min(cellWidth, cellHeight) * 2)
                    .frame(width: cellWidth * 2, height: cellHeight * 2)
                    .position(x: cellWidth * 4, y: cellHeight * 1)
                // Bottom palace: center at (8,4) in grid lines
                PalaceView(size: min(cellWidth, cellHeight) * 2)
                    .frame(width: cellWidth * 2, height: cellHeight * 2)
                    .position(x: cellWidth * 4, y: cellHeight * 8)
            }
        }
        .padding()
    }
    
    private func handleSquareTap(at position: Position) {
        if let selectedPiece = board.selectedPiece {
            if board.validMoves.contains(where: { $0.row == position.row && $0.col == position.col }) {
                _ = board.movePiece(from: selectedPiece, to: position)
            } else {
                board.selectedPiece = nil
                board.validMoves = []
            }
        } else {
            board.selectPiece(at: position)
        }
    }
}

#Preview {
    BoardView(board: Board(), squareSize: 40)
} 
