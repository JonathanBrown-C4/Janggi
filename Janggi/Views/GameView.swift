import SwiftUI

struct GameView: View {
    @StateObject private var board = Board()
    @StateObject private var settings = Settings()
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
                // Reset Board button
                Button(action: { board.setupBoard() }) {
                    Text("Reset Board")
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.bottom, 8)
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
            
            // Toast notification for check
            if board.showCheckToast {
                VStack {
                    Spacer()
                    Text(board.checkToastMessage)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.bottom, 100)
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration: 0.3), value: board.showCheckToast)
            }
        }
        .padding()
        .sheet(isPresented: $showSettings) {
            SettingsView(settings: settings)
        }
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
