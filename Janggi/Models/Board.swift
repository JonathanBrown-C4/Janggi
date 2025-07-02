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
    @Published var capturablePieces: [Position] = []
    @Published var capturedRedPieces: [Piece] = []
    @Published var capturedBluePieces: [Piece] = []
    @Published var redGeneralInCheck: Bool = false
    @Published var blueGeneralInCheck: Bool = false
    @Published var showMessage: ((String) -> Void)?
    var pieceCaptureEvent: ((Piece) -> Void)?
    
    init() {
        setupBoard()
    }
    
    func setupBoard() {
        // Reset all game state
        isRedTurn = true
        gameState = .playing
        selectedPiece = nil
        validMoves = []
        capturablePieces = []
        capturedRedPieces = []
        capturedBluePieces = []
        redGeneralInCheck = false
        blueGeneralInCheck = false
        
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
        
        // Soldiers
        for col in [0, 2, 4, 6, 8] {
            pieces[3][col] = Soldier(isRed: true, position: Position(row: 3, col: col))
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
        
        // Soldiers
        for col in [0, 2, 4, 6, 8] {
            pieces[6][col] = Soldier(isRed: false, position: Position(row: 6, col: col))
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
            pieceCaptureEvent?(captured)
        } else {
            SoundManager.shared.playMoveSound()
        }
        
        // Move the piece
        pieces[to.row][to.col] = piece
        pieces[from.row][from.col] = nil
        piece.currentPosition = to
        
        // Only toggle turn after successful move (no automatic check detection)
        isRedTurn.toggle()
        
        // Clear selection and valid moves
        selectedPiece = nil
        validMoves = []
        capturablePieces = []
        
        return capturedPiece
    }
    
    func selectPiece(at position: Position) {
        guard let piece = pieceAt(position), piece.isRed == isRedTurn else {
            selectedPiece = nil
            validMoves = []
            capturablePieces = []
            return
        }
        
        selectedPiece = position
        validMoves = validMoves(for: piece)
        
        // Identify capturable pieces (opponent pieces that can be captured)
        capturablePieces = validMoves.compactMap { movePosition in
            if let targetPiece = pieceAt(movePosition), targetPiece.isRed != piece.isRed {
                return movePosition
            }
            return nil
        }
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
    
    func checkForCheck() {
        // Check if the opponent's general is in check
        let opponentColor: PieceColor = isRedTurn ? .blue : .red
        let isInCheck = isGeneralInCheck(for: opponentColor)
        
        // Update the check state
        if opponentColor == .red {
            redGeneralInCheck = isInCheck
        } else {
            blueGeneralInCheck = isInCheck
        }
        
        // Show toast message (always)
        let generalName = opponentColor == .red ? "Red" : "Blue"
        let message = isInCheck ? "\(generalName) General is in check!" : "\(generalName) General is safe."
        showMessage?(message)
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
    
    // Returns all valid moves for a piece using its movement rules
    func validMoves(for piece: Piece) -> [Position] {
        var moves: [Position] = []
        
        for rule in piece.movementRules {
            switch rule.direction {
            case .orthogonal:
                moves.append(contentsOf: getOrthogonalMoves(for: piece, rule: rule))
            case .diagonal:
                moves.append(contentsOf: getDiagonalMoves(for: piece, rule: rule))
            case .lShape:
                moves.append(contentsOf: getLShapeMoves(for: piece, rule: rule))
            case .custom:
                moves.append(contentsOf: getCustomMoves(for: piece, rule: rule))
            }
        }
        
        return moves
    }
    
    // Helper method for orthogonal movement (up, down, left, right)
    private func getOrthogonalMoves(for piece: Piece, rule: MovementRule) -> [Position] {
        var moves: [Position] = []
        let start = piece.currentPosition
        
        // Special handling for Soldier directional movement
        if piece is Soldier {
            let soldier = piece as! Soldier
            let directions = getSoldierDirections(soldier)
            
            for (rowDelta, colDelta) in directions {
                let pos = Position(row: start.row + rowDelta, col: start.col + colDelta)
                
                if piece.isWithinBounds(pos) {
                    if let targetPiece = pieceAt(pos) {
                        if targetPiece.isRed != piece.isRed {
                            moves.append(pos)
                        }
                    } else {
                        moves.append(pos)
                    }
                }
            }
            return moves
        }
        
        let directions = [(0, 1), (0, -1), (1, 0), (-1, 0)] // right, left, down, up
        
        for (rowDelta, colDelta) in directions {
            var distance = 1
            var currentRow = start.row + rowDelta
            var currentCol = start.col + colDelta
            
            while (rule.maxDistance == 0 || distance <= rule.maxDistance) && 
                  piece.isWithinBounds(Position(row: currentRow, col: currentCol)) {
                let pos = Position(row: currentRow, col: currentCol)
                
                // Check palace restrictions
                if rule.palaceRestricted && !isInPalace(pos, isRed: piece.isRed) {
                    break
                }
                
                if let targetPiece = pieceAt(pos) {
                    switch rule.blockingRules {
                    case .none:
                        // Can move through pieces
                        moves.append(pos)
                    case .stopAtFirst:
                        // Can capture enemy piece
                        if targetPiece.isRed != piece.isRed {
                            moves.append(pos)
                        }
                        break
                    case .jumpOver:
                        // Cannon logic - needs platform
                        if !rule.requiresPlatform {
                            // Regular piece, not cannon
                            if targetPiece.isRed != piece.isRed {
                                moves.append(pos)
                            }
                            break
                        }
                        // Cannon logic would be handled in custom moves
                        break
                    case .centerBlock:
                        // Horse logic - blocked by center
                        break
                    }
                    break
                } else {
                    // Empty square
                    if rule.requiresPlatform {
                        // Cannon needs platform to move
                        break
                    } else {
                        moves.append(pos)
                    }
                }
                
                currentRow += rowDelta
                currentCol += colDelta
                distance += 1
            }
        }
        
        return moves
    }
    
    // Helper method to get soldier movement directions
    private func getSoldierDirections(_ soldier: Soldier) -> [(Int, Int)] {
        var directions: [(Int, Int)] = []
        
        // Red soldiers can only move down, left, and right (not up)
        // Blue soldiers can only move up, left, and right (not down)
        if soldier.isRed {
            directions.append((1, 0))   // down
        } else {
            directions.append((-1, 0))  // up
        }
        
        // Sideways movement (left and right)
        directions.append((0, 1))   // right
        directions.append((0, -1))  // left
        
        return directions
    }
    
    // Helper method for diagonal movement
    private func getDiagonalMoves(for piece: Piece, rule: MovementRule) -> [Position] {
        var moves: [Position] = []
        let start = piece.currentPosition
        let directions = [(1, 1), (1, -1), (-1, 1), (-1, -1)] // down-right, down-left, up-right, up-left
        
        for (rowDelta, colDelta) in directions {
            var distance = 1
            var currentRow = start.row + rowDelta
            var currentCol = start.col + colDelta
            
            while (rule.maxDistance == 0 || distance <= rule.maxDistance) && 
                  piece.isWithinBounds(Position(row: currentRow, col: currentCol)) {
                let pos = Position(row: currentRow, col: currentCol)
                
                // Check palace restrictions
                if rule.palaceRestricted && !isInPalace(pos, isRed: piece.isRed) {
                    break
                }
                
                if let targetPiece = pieceAt(pos) {
                    if targetPiece.isRed != piece.isRed {
                        moves.append(pos)
                    }
                    break
                } else {
                    moves.append(pos)
                }
                
                currentRow += rowDelta
                currentCol += colDelta
                distance += 1
            }
        }
        
        return moves
    }
    
    // Helper method for L-shaped movement (Horse)
    private func getLShapeMoves(for piece: Piece, rule: MovementRule) -> [Position] {
        var moves: [Position] = []
        let start = piece.currentPosition
        
        // Horse L-shaped moves: (target position, blocking position)
        let horseMoves = [
            (Position(row: start.row - 2, col: start.col + 1), Position(row: start.row - 1, col: start.col)), // Up 2, right 1
            (Position(row: start.row - 2, col: start.col - 1), Position(row: start.row - 1, col: start.col)), // Up 2, left 1
            (Position(row: start.row + 2, col: start.col + 1), Position(row: start.row + 1, col: start.col)), // Down 2, right 1
            (Position(row: start.row + 2, col: start.col - 1), Position(row: start.row + 1, col: start.col)), // Down 2, left 1
            (Position(row: start.row - 1, col: start.col + 2), Position(row: start.row, col: start.col + 1)), // Up 1, right 2
            (Position(row: start.row + 1, col: start.col + 2), Position(row: start.row, col: start.col + 1)), // Down 1, right 2
            (Position(row: start.row - 1, col: start.col - 2), Position(row: start.row, col: start.col - 1)), // Up 1, left 2
            (Position(row: start.row + 1, col: start.col - 2), Position(row: start.row, col: start.col - 1))  // Down 1, left 2
        ]
        
        for (target, block) in horseMoves {
            if piece.isWithinBounds(target) && piece.isWithinBounds(block) {
                if pieceAt(block) == nil {
                    if let targetPiece = pieceAt(target) {
                        if targetPiece.isRed != piece.isRed {
                            moves.append(target)
                        }
                    } else {
                        moves.append(target)
                    }
                }
            }
        }
        
        return moves
    }
    
    // Helper method for custom movement (Elephant, Cannon)
    private func getCustomMoves(for piece: Piece, rule: MovementRule) -> [Position] {
        var moves: [Position] = []
        let start = piece.currentPosition
        
        // Elephant logic
        if piece is Elephant {
            // Elephant moves: 1 step orthogonal, then 2 steps diagonal from that position
            let orthogonalDirections = [(0, 1), (0, -1), (1, 0), (-1, 0)] // right, left, down, up
            let diagonalDirections = [(1, 1), (1, -1), (-1, 1), (-1, -1)] // down-right, down-left, up-right, up-left
            
            for (orthRowDelta, orthColDelta) in orthogonalDirections {
                // First step: move one step orthogonally
                let intermediateRow = start.row + orthRowDelta
                let intermediateCol = start.col + orthColDelta
                let intermediatePos = Position(row: intermediateRow, col: intermediateCol)
                
                // Check if intermediate position is valid and empty
                if piece.isWithinBounds(intermediatePos) && pieceAt(intermediatePos) == nil {
                    // Second step: from intermediate position, move 2 steps diagonally
                    for (diagRowDelta, diagColDelta) in diagonalDirections {
                        let targetRow = intermediateRow + (diagRowDelta * 2)
                        let targetCol = intermediateCol + (diagColDelta * 2)
                        let targetPos = Position(row: targetRow, col: targetCol)
                        
                        if piece.isWithinBounds(targetPos) {
                            if let targetPiece = pieceAt(targetPos) {
                                if targetPiece.isRed != piece.isRed {
                                    moves.append(targetPos)
                                }
                            } else {
                                moves.append(targetPos)
                            }
                        }
                    }
                }
            }
        }
        
        // Cannon logic
        if piece is Cannon {
            let isInPalace = isInPalace(start, isRed: piece.isRed)
            
            // Orthogonal directions
            let orthogonalDirections = [(0, 1), (0, -1), (1, 0), (-1, 0)] // right, left, down, up
            
            // Add diagonal directions if in palace
            var allDirections = orthogonalDirections
            if isInPalace {
                let diagonalDirections = [(1, 1), (1, -1), (-1, 1), (-1, -1)] // down-right, down-left, up-right, up-left
                allDirections.append(contentsOf: diagonalDirections)
            }
            
            for (rowDelta, colDelta) in allDirections {
                var currentRow = start.row + rowDelta
                var currentCol = start.col + colDelta
                var foundPlatform = false
                var platformPos: Position? = nil
                
                while piece.isWithinBounds(Position(row: currentRow, col: currentCol)) {
                    let pos = Position(row: currentRow, col: currentCol)
                    
                    if let pieceAtPos = pieceAt(pos) {
                        if !foundPlatform {
                            // Found first platform
                            // Cannons cannot use other cannons as platforms
                            if pieceAtPos is Cannon {
                                break
                            }
                            foundPlatform = true
                            platformPos = pos
                        } else {
                            // Found another piece after platform
                            // Cannons cannot capture other cannons
                            if pieceAtPos is Cannon {
                                break
                            }
                            if pieceAtPos.isRed != piece.isRed {
                                // Can capture enemy piece on opposite side of platform
                                moves.append(pos)
                            }
                            // Stop after finding any piece after platform
                            break
                        }
                    } else if foundPlatform {
                        // Can only move to empty squares after finding platform
                        // Check if we're on the opposite side of the platform
                        let isOppositeSide = (rowDelta > 0 && pos.row > platformPos!.row) ||
                                           (rowDelta < 0 && pos.row < platformPos!.row) ||
                                           (colDelta > 0 && pos.col > platformPos!.col) ||
                                           (colDelta < 0 && pos.col < platformPos!.col)
                        
                        if isOppositeSide {
                            moves.append(pos)
                        }
                    }
                    
                    currentRow += rowDelta
                    currentCol += colDelta
                }
            }
        }
        
        return moves
    }
    
    // Helper method to check if position is in palace
    private func isInPalace(_ position: Position, isRed: Bool) -> Bool {
        let palaceRows = isRed ? (0...2) : (7...9)
        let palaceCols = 3...5
        return palaceRows.contains(position.row) && palaceCols.contains(position.col)
    }
}
