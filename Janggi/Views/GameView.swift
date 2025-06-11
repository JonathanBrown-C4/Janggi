import SwiftUI

struct GameView: View {
    @StateObject private var board = Board()
    private let squareSize: CGFloat = 40
    
    var body: some View {
        HStack(spacing: 20) {
            // Captured pieces for Red
            CapturedPiecesView(pieces: board.capturedRedPieces, color: .red)
            
            // Main game board
            VStack {
                Text("Janggi")
                    .font(.largeTitle)
                    .padding()
                
                // Game state display
                Group {
                    switch board.gameState {
                    case .playing:
                        Text(board.isRedTurn ? "Red's Turn" : "Blue's Turn")
                            .font(.title2)
                            .foregroundColor(board.isRedTurn ? .red : .blue)
                    case .check:
                        Text("\(board.isRedTurn ? "Red" : "Blue") is in Check!")
                            .font(.title2)
                            .foregroundColor(.red)
                    case .checkmate:
                        Text("Checkmate! \(board.isRedTurn ? "Blue" : "Red") wins!")
                            .font(.title2)
                            .foregroundColor(.green)
                    case .stalemate:
                        Text("Stalemate! Game is a draw.")
                            .font(.title2)
                            .foregroundColor(.orange)
                    }
                }
                .padding(.bottom)
                
                // Game board
                BoardView(board: board, squareSize: squareSize)
                
                // Reset button
                if board.gameState == .checkmate || board.gameState == .stalemate {
                    Button("New Game") {
                        board.setupBoard()
                    }
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                }
            }
            
            // Captured pieces for Blue
            CapturedPiecesView(pieces: board.capturedBluePieces, color: .blue)
        }
        .padding()
    }
    
    private func handleSquareTap(at position: Position) {
        if let selectedPiece = board.selectedPiece {
            // If a piece is already selected, try to move it
            if board.validMoves.contains(where: { $0.row == position.row && $0.col == position.col }) {
                board.movePiece(from: selectedPiece, to: position)
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
    GameView()
} 