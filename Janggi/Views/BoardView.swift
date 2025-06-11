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
            
            // Grid lines
            VStack(spacing: 0) {
                ForEach(0..<10) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<9) { col in
                            Rectangle()
                                .stroke(Color.black, lineWidth: 1)
                                .frame(width: squareSize, height: squareSize)
                                .background(
                                    Group {
                                        if let selected = board.selectedPiece,
                                           selected.row == row && selected.col == col {
                                            Color.yellow.opacity(0.3)
                                        } else if board.validMoves.contains(where: { $0.row == row && $0.col == col }) {
                                            Color.green.opacity(0.3)
                                        }
                                    }
                                )
                                .onTapGesture {
                                    handleSquareTap(at: Position(row: row, col: col))
                                }
                        }
                    }
                }
            }
            
            // Palace diagonals
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
            
            // Pieces
            ForEach(0..<10) { row in
                ForEach(0..<9) { col in
                    if let piece = board.pieces[row][col] {
                        let pieceView = PieceView(pieceType: piece.type, color: piece.color, size: squareSize * 0.8)
                        pieceView
                            .position(x: CGFloat(col) * squareSize + squareSize/2,
                                    y: CGFloat(row) * squareSize + squareSize/2)
                            .onTapGesture {
                                handleSquareTap(at: Position(row: row, col: col))
                            }
                    }
                }
            }
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