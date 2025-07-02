import SwiftUI

struct GameView: View {
    @StateObject private var board = Board()
    @StateObject private var settings = Settings()
    @StateObject private var messageManager = MessageManager()
    private let squareSize: CGFloat = 40
    @State private var showCapturedOverlay = false
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Top bar with expand/collapse button and settings
                HStack {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 8)
                    .padding(.leading, 16)
                    
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
                        VStack(spacing: 8) {
                            Text(board.isRedTurn ? "Red's Turn" : "Blue's Turn")
                                .font(.title2)
                                .foregroundColor(board.isRedTurn ? .red : .blue)
                            
                            // Manual check button
                            Button("In Check?") {
                                board.checkForCheck()
                            }
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    case .check:
                        VStack(spacing: 8) {
                            Text("\(board.isRedTurn ? "Red" : "Blue") is in Check!")
                                .font(.title2)
                                .foregroundColor(.red)
                            
                            // Manual check button
                            Button("In Check?") {
                                board.checkForCheck()
                            }
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
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
                    BoardView(board: board, settings: settings, squareSize: squareSize)
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
            
            // Toast notification (top right)
            ToastView(message: messageManager.message, show: messageManager.show)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: messageManager.show)
        }
        .padding()
        .onAppear {
            board.showMessage = { msg in
                messageManager.showMessage(msg)
            }
            board.pieceCaptureEvent = { capturedPiece in
                messageManager.showMessage("Captured a \(capturedPiece.imageName.capitalized.replacingOccurrences(of: "_", with: " "))!")
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(settings: settings, onResetBoard: {
                board.setupBoard()
                messageManager.showMessage("Board reset.")
            })
        }
    }
    
    private func handleSquareTap(at position: Position) {
        let tappedPiece = board.pieceAt(position)
        let isCurrentPlayersPiece = tappedPiece?.isRed == board.isRedTurn
        let isOpponentPiece = tappedPiece != nil && tappedPiece?.isRed != board.isRedTurn
        let isEmpty = tappedPiece == nil
        
        if let selected = board.selectedPiece {
            let selectedPiece = board.pieceAt(selected)
            // If tapping your own piece, change selection
            if isCurrentPlayersPiece {
                board.selectPiece(at: position)
            } else {
                // Tapping opponent or empty: try to move
                if board.validMoves.contains(where: { $0.row == position.row && $0.col == position.col }) {
                    _ = board.movePiece(from: selected, to: position)
                } else {
                    messageManager.showMessage("Not a valid move.")
                    // Keep selection so user can try again
                }
            }
        } else {
            // No piece selected yet
            if isCurrentPlayersPiece {
                board.selectPiece(at: position)
            } else {
                // Ignore taps on opponent pieces or empty squares
                messageManager.showMessage("Select one of your own pieces to move.")
            }
        }
    }
}

#Preview {
    GameView()
} 
