import SwiftUI

struct GameView: View {
    @StateObject private var board = Board()
    private let squareSize: CGFloat = 40
    @State private var showCapturedOverlay = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Top bar with expand/collapse button
                HStack {
                    Spacer()
                    Button(action: { withAnimation { showCapturedOverlay.toggle() } }) {
                        Image(systemName: showCapturedOverlay ? "chevron.up" : "chevron.down")
                        Text(showCapturedOverlay ? "Hide Captured" : "Show Captured")
                    }
                    .padding(.top, 8)
                    .padding(.trailing, 16)
                }
                // Title
                Text("Janggi")
                    .font(.largeTitle)
                    .padding(.top, 8)
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
                // Board with border, background, and padding
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.8, green: 0.7, blue: 0.5))
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.darkGray), lineWidth: 6)
                    BoardView(board: board, squareSize: squareSize)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(24)
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
            // Captured pieces overlay
            if showCapturedOverlay {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { withAnimation { showCapturedOverlay = false } }
                VStack(spacing: 24) {
                    Text("Captured Pieces")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 32)
                    HStack(spacing: 40) {
                        VStack {
                            Text("Red's Captured")
                                .foregroundColor(.red)
                            CapturedPiecesView(pieces: board.capturedRedPieces, color: .red)
                        }
                        VStack {
                            Text("Blue's Captured")
                                .foregroundColor(.blue)
                            CapturedPiecesView(pieces: board.capturedBluePieces, color: .blue)
                        }
                    }
                    Spacer()
                    Button(action: { withAnimation { showCapturedOverlay = false } }) {
                        Text("Close")
                            .font(.title2)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 32)
                }
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.7))
                .cornerRadius(20)
                .padding(.horizontal, 24)
                .transition(.move(edge: .top))
            }
        }
        .padding()
    }
    
    private func handleSquareTap(at position: Position) {
        if let selectedPiece = board.selectedPiece {
            if board.validMoves.contains(where: { $0.row == position.row && $0.col == position.col }) {
                board.movePiece(from: selectedPiece, to: position)
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
    GameView()
} 
