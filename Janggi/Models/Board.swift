import SwiftUI
import Foundation

enum GameState {
    case playing
    case check
    case checkmate
    case stalemate
}

enum PieceColor {
    case red
    case blue
}

class Board: ObservableObject {
    @Published var pieces: [[Piece?]] = Array(repeating: Array(repeating: nil, count: 9), count: 10)
    @Published var isRedTurn: Bool = true
    @Published var gameState: GameState = .playing
    @Published var selectedPiece: Position?
    @Published var validMoves: [Position] = []
    @Published var capturedRedPieces: [Piece] = []
    @Published var capturedBluePieces: [Piece] = []
    
    init() {
        setupBoard()
    }
    
    func setupBoard() {
        // Reset all game state
        isRedTurn = true
        gameState = .playing
        selectedPiece = nil
        validMoves = []
        capturedRedPieces = []
        capturedBluePieces = []
        
        // Clear the board
        pieces = Array(repeating: Array(repeating: nil, count: 9), count: 10)
        
        // Setup Red pieces
        // General
        pieces[1][4] = General(isRed: true, position: Position(row: 1, col: 4))
        
        // Guards
        pieces[0][3] = Guard(isRed: true, position: Position(row: 0, col: 3))
        pieces[0][5] = Guard(isRed: true, position: Position(row: 0, col: 5))
        
        // Elephants
        pieces[0][2] = Elephant(isRed: true, position: Position(row: 0, col: 2))
        pieces[0][6] = Elephant(isRed: true, position: Position(row: 0, col: 6))
        
        // Horses
        pieces[0][1] = Horse(isRed: true, position: Position(row: 0, col: 1))
        pieces[0][7] = Horse(isRed: true, position: Position(row: 0, col: 7))
        
        // Chariots
        pieces[0][0] = Chariot(isRed: true, isLeft: true)
        pieces[0][8] = Chariot(isRed: true, isLeft: false)
        
        // Cannons
        pieces[2][1] = Cannon(isRed: true, position: Position(row: 2, col: 1))
        pieces[2][7] = Cannon(isRed: true, position: Position(row: 2, col: 7))
        
        // Pawns
        for col in [0, 2, 4, 6, 8] {
            pieces[3][col] = Pawn(isRed: true, position: Position(row: 3, col: col))
        }
        
        // Setup Blue pieces
        // General
        pieces[8][4] = General(isRed: false, position: Position(row: 8, col: 4))
        
        // Guards
        pieces[9][3] = Guard(isRed: false, position: Position(row: 9, col: 3))
        pieces[9][5] = Guard(isRed: false, position: Position(row: 9, col: 5))
        
        // Elephants
        pieces[9][2] = Elephant(isRed: false, position: Position(row: 9, col: 2))
        pieces[9][6] = Elephant(isRed: false, position: Position(row: 9, col: 6))
        
        // Horses
        pieces[9][1] = Horse(isRed: false, position: Position(row: 9, col: 1))
        pieces[9][7] = Horse(isRed: false, position: Position(row: 9, col: 7))
        
        // Chariots
        pieces[9][0] = Chariot(isRed: false, isLeft: true)
        pieces[9][8] = Chariot(isRed: false, isLeft: false)
        
        // Cannons
        pieces[7][1] = Cannon(isRed: false, position: Position(row: 7, col: 1))
        pieces[7][7] = Cannon(isRed: false, position: Position(row: 7, col: 7))
        
        // Pawns
        for col in [0, 2, 4, 6, 8] {
            pieces[6][col] = Pawn(isRed: false, position: Position(row: 6, col: col))
        }
    }
    
    func pieceAt(_ position: Position) -> Piece? {
        guard position.row >= 0 && position.row < pieces.count &&
              position.col >= 0 && position.col < pieces[0].count else {
            return nil
        }
        return pieces[position.row][position.col]
    }
    
    func movePiece(from: Position, to: Position) -> Piece? {
        // Check bounds for both positions
        guard from.row >= 0 && from.row < pieces.count &&
              from.col >= 0 && from.col < pieces[0].count &&
              to.row >= 0 && to.row < pieces.count &&
              to.col >= 0 && to.col < pieces[0].count else {
            return nil
        }
        
        guard let piece = pieces[from.row][from.col],
              piece.isRed == isRedTurn else { return nil }
        
        // Store the captured piece if any
        let capturedPiece = pieces[to.row][to.col]
        if let captured = capturedPiece {
            if captured.isRed {
                capturedRedPieces.append(captured)
            } else {
                capturedBluePieces.append(captured)
            }
            SoundManager.shared.playCaptureSound()
        } else {
            SoundManager.shared.playMoveSound()
        }
        
        // Move the piece
        pieces[to.row][to.col] = piece
        pieces[from.row][from.col] = nil
        piece.currentPosition = to
        
        // Only toggle turn and update game state after successful move
        isRedTurn.toggle()
        updateGameState()
        
        // Clear selection and valid moves
        selectedPiece = nil
        validMoves = []
        
        return capturedPiece
    }
    
    func selectPiece(at position: Position) {
        guard let piece = pieceAt(position), piece.isRed == isRedTurn else {
            selectedPiece = nil
            validMoves = []
            return
        }
        
        selectedPiece = position
        validMoves = validMoves(for: piece)
    }
    
    func updateGameState() {
        // Check for checkmate first
        if isGeneralInCheck(for: .red) && isCheckmate(for: .red) {
            gameState = .checkmate
            return
        }
        if isGeneralInCheck(for: .blue) && isCheckmate(for: .blue) {
            gameState = .checkmate
            return
        }
        
        // Then check for check
        if isGeneralInCheck(for: .red) || isGeneralInCheck(for: .blue) {
            gameState = .check
            return
        }
        
        // Then check for bikjang
        if isBikjang() {
            gameState = .stalemate
            return
        }
        
        // Finally check for stalemate
        if isStalemate() {
            gameState = .stalemate
            return
        }
        
        // If none of the above, the game is in playing state
        gameState = .playing
    }
    
    func isGeneralInCheck(for color: PieceColor) -> Bool {
        print("\nChecking if \(color) general is in check...")
        // Find the general's position
        var generalPosition: Position?
        for row in 0..<10 {
            for col in 0..<9 {
                if let piece = pieceAt(Position(row: row, col: col)) {
                    if (color == .red && piece.isRed && piece.imageName == "red_general") ||
                       (color == .blue && !piece.isRed && piece.imageName == "blue_general") {
                        generalPosition = piece.currentPosition
                        break
                    }
                }
            }
        }
        
        // Thread safety: Make a local copy to ensure thread safety
        guard let generalPos = generalPosition else {
            print("Could not find \(color) general")
            return false
        }
        
        print("\(color) general position: \(generalPos)")
        
        // Check if any opponent piece can move to the general's position
        let isOpponentRed = color == .blue
        for row in 0..<10 {
            for col in 0..<9 {
                if let piece = pieceAt(Position(row: row, col: col)), piece.isRed == isOpponentRed {
                    print("Checking piece: \(type(of: piece)) at (\(row), \(col)), address: \(Unmanaged.passUnretained(piece).toOpaque())")
                    let currentGeneralPos = generalPos
                    print("Before validMoves for piece at (\(row), \(col))")
                    let moves = validMoves(for: piece)
                    print("After validMoves for piece at (\(row), \(col))")
                    if moves.contains(currentGeneralPos) {
                        print("\(piece.imageName) at (\(row), \(col)) can check the \(color) general")
                        return true
                    }
                }
            }
        }
        
        print("\(color) general is not in check")
        return false
    }
    
    func isCheckmate(for color: PieceColor) -> Bool {
        print("\nChecking for checkmate for \(color)...")
        // First check if the general is in check
        if !isGeneralInCheck(for: color) {
            print("\(color) general is not in check, cannot be checkmate")
            return false
        }
        
        // Check if any piece can make a move that gets the general out of check
        let isRed = color == .red
        for row in 0..<10 {
            for col in 0..<9 {
                if let piece = pieceAt(Position(row: row, col: col)), piece.isRed == isRed {
                    let moves = validMoves(for: piece)
                    for move in moves {
                        // Simulate the move
                        let originalPosition = piece.currentPosition
                        let capturedPiece = pieces[move.row][move.col]
                        
                        // Make the move
                        pieces[move.row][move.col] = piece
                        pieces[originalPosition.row][originalPosition.col] = nil
                        piece.currentPosition = move
                        
                        // Check if the general is still in check
                        let stillInCheck = isGeneralInCheck(for: color)
                        
                        // Undo the move
                        pieces[originalPosition.row][originalPosition.col] = piece
                        pieces[move.row][move.col] = capturedPiece
                        piece.currentPosition = originalPosition
                        
                        // If we found a move that gets the general out of check, it's not checkmate
                        if !stillInCheck {
                            print("Found a move that gets the \(color) general out of check")
                            return false
                        }
                    }
                }
            }
        }
        
        print("No moves available to get the \(color) general out of check - it's checkmate!")
        return true
    }
    
    func isStalemate() -> Bool {
        print("\nChecking for stalemate...")
        // First check if either general is in check
        if isGeneralInCheck(for: .red) || isGeneralInCheck(for: .blue) {
            print("Stalemate check: A general is in check, not a stalemate")
            return false
        }
        
        // Check if either player has any legal moves
        let redHasMoves = hasLegalMoves(for: .red)
        let blueHasMoves = hasLegalMoves(for: .blue)
        
        print("Stalemate check: Red has moves: \(redHasMoves), Blue has moves: \(blueHasMoves)")
        
        // If either player has legal moves, it's not a stalemate
        if redHasMoves || blueHasMoves {
            print("Stalemate check: At least one player has legal moves, not a stalemate")
            return false
        }
        
        print("Stalemate check: No legal moves for either player, this is a stalemate")
        return true
    }
    
    private func hasLegalMoves(for color: PieceColor) -> Bool {
        print("Checking for legal moves for \(color)...")
        // Iterate through all pieces of the given color
        for row in 0..<10 {
            for col in 0..<9 {
                if let piece = pieceAt(Position(row: row, col: col)), piece.color == color {
                    print("Checking piece \(piece.imageName) at (\(row), \(col))")
                    let moves = validMoves(for: piece)
                    for move in moves {
                        // Try the move
                        let originalPosition = piece.currentPosition
                        let capturedPiece = movePiece(from: originalPosition, to: move)
                        
                        // Check if the move would put or leave the general in check
                        let wouldBeInCheck = isGeneralInCheck(for: color)
                        
                        // Undo the move
                        _ = movePiece(from: move, to: originalPosition)
                        if let captured = capturedPiece {
                            placePiece(captured, at: move)
                        }
                        
                        if !wouldBeInCheck {
                            print("Found legal move: \(piece.imageName) from \(originalPosition) to \(move)")
                            return true
                        }
                    }
                }
            }
        }
        print("No legal moves found for \(color)")
        return false
    }
    
    func isBikjang() -> Bool {
        print("\nChecking for bikjang...")
        
        // Find both generals
        var redGeneralPos: Position?
        var blueGeneralPos: Position?
        
        for row in 0..<10 {
            for col in 0..<9 {
                if let piece = pieceAt(Position(row: row, col: col)) {
                    if piece.isRed && piece.imageName == "red_general" {
                        redGeneralPos = piece.currentPosition
                    } else if !piece.isRed && piece.imageName == "blue_general" {
                        blueGeneralPos = piece.currentPosition
                    }
                }
            }
        }
        
        guard let redPos = redGeneralPos, let bluePos = blueGeneralPos else {
            print("Could not find both generals")
            return false
        }
        
        // Check if generals are in the same column
        if redPos.col != bluePos.col {
            print("Generals are not in the same column")
            return false
        }
        
        // Check if there are any pieces between the generals
        let minRow = min(redPos.row, bluePos.row)
        let maxRow = max(redPos.row, bluePos.row)
        
        for row in (minRow + 1)..<maxRow {
            if pieceAt(Position(row: row, col: redPos.col)) != nil {
                print("Found piece between generals")
                return false
            }
        }
        
        print("Generals are facing each other with no pieces between them - this is bikjang!")
        return true
    }
    
    private func findGeneralPosition(for color: PieceColor) -> Position? {
        for row in 0..<10 {
            for col in 0..<9 {
                if let piece = pieces[row][col] as? General, piece.isRed == (color == .red) {
                    return Position(row: row, col: col)
                }
            }
        }
        return nil
    }
    
    private func placePiece(_ piece: Piece, at position: Position) {
        pieces[position.row][position.col] = piece
        piece.currentPosition = position
    }
    
    private var currentPlayer: PieceColor {
        isRedTurn ? .red : .blue
    }
    
    // Returns all valid moves for a piece using its movement rules (Chariot only for now)
    func validMoves(for piece: Piece) -> [Position] {
        var moves: [Position] = []
        let start = piece.currentPosition
        for rule in piece.movementRules {
            var distance = 1
            var next = start
            while rule.maxDistance == 0 || distance <= rule.maxDistance {
                switch rule.direction {
                case .up: next = Position(row: next.row - 1, col: next.col)
                case .down: next = Position(row: next.row + 1, col: next.col)
                case .left: next = Position(row: next.row, col: next.col - 1)
                case .right: next = Position(row: next.row, col: next.col + 1)
                default: break // Only straight lines for Chariot
                }
                if !piece.isWithinBounds(next) { break }
                if let target = pieceAt(next) {
                    if target.isRed != piece.isRed {
                        moves.append(next)
                    }
                    break
                }
                moves.append(next)
                distance += 1
            }
        }
        return moves
    }
}
