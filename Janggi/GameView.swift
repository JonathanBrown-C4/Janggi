import SwiftUI

struct GameView: View {
    @StateObject private var board = Board()
    private let squareSize: CGFloat = 40
    
    var body: some View {
        HStack(spacing: 20) {
            // Captured pieces for Red
            VStack {
                Text("Captured")
                    .font(.headline)
                    .foregroundColor(.red)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 30))], spacing: 5) {
                        ForEach(board.capturedRedPieces, id: \.imageName) { piece in
                            Image(piece.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        }
                    }
                }
                .frame(width: 100, height: 200)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            
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
                        path.move(to: CGPoint(x: squareSize * 3, y: 0))
                        path.addLine(to: CGPoint(x: squareSize * 5, y: squareSize * 2))
                        path.move(to: CGPoint(x: squareSize * 5, y: 0))
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
                                Image(piece.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: squareSize * 0.8, height: squareSize * 0.8)
                                    .position(x: CGFloat(col) * squareSize + squareSize/2,
                                            y: CGFloat(row) * squareSize + squareSize/2)
                            }
                        }
                    }
                }
                .padding()
                
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
            VStack {
                Text("Captured")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 30))], spacing: 5) {
                        ForEach(board.capturedBluePieces, id: \.imageName) { piece in
                            Image(piece.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        }
                    }
                }
                .frame(width: 100, height: 200)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
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

#Preview {
    GameView()
} 