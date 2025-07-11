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
                    BoardView(board: board, settings: settings, squareSize: squareSize, onSquareTap: handleSquareTap)
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
            board.moveAttemptEvent = { success, message in
                if !success {
                    messageManager.showMessage(message)
                }
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
        
        if let selected = board.selectedPiece {
            if isCurrentPlayersPiece, let tapped = tappedPiece {
                // Change selection to the new piece
                board.selectPiece(tapped)
            } else {
                // Always try to move, let Board handle validity and events
                _ = board.movePiece(from: selected, to: position)
                // If move is invalid, selection is kept
            }
        } else {
            if isCurrentPlayersPiece, let tapped = tappedPiece {
                board.selectPiece(tapped)
            } else {
                messageManager.showMessage("Select one of your own pieces to move.")
            }
        }
    }
}

#Preview {
    GameView()
} 
