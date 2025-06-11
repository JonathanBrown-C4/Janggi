import SwiftUI

struct BoardView: View {
    @ObservedObject var board: Board
    let squareSize: CGFloat
    
    var body: some View {
        ZStack {
            // Board background
            Rectangle()
                .fill(Color(red: 0.8, green: 0.7, blue: 0.5))
                .frame(width: squareSize * 9, height: squareSize * 10)
            
            // Grid and pieces
            BoardGridView(board: board, squareSize: squareSize, onSquareTap: handleSquareTap)
            PalaceView(squareSize: squareSize)
            PieceGridView(board: board, squareSize: squareSize, onSquareTap: handleSquareTap)
        }
        .padding()
    }
    
    private func handleSquareTap(at position: Position) {
        if let selectedPiece = board.selectedPiece {
            // If a piece is already selected, try to move it
            if board.validMoves.contains(where: { $0.row == position.row && $0.col == position.col }) {
                _ = board.movePiece(from: selectedPiece, to: position)
            } else {
                // If the move is invalid, deselect the piece
                board.selectedPiece = nil
                board.validMoves = []
            }
        } else {
            // If no piece is selected, try to select one
            board.selectPiece(at: position)
        }
    }
}

#Preview {
    BoardView(board: Board(), squareSize: 40)
} 