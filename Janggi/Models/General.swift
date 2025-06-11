import SwiftUI

class General: Piece {
    init(isRed: Bool, position: Position) {
        let imageName = isRed ? "red_general" : "blue_general"
        super.init(imageName: imageName, isRed: isRed, position: position, size: .large)
    }
    
    override func validMoves(board: Board) -> [Position] {
        var moves: [Position] = []
        let palace = isRed ? (0...2) : (7...9)
        let centerCols = 3...5
        
        // Define all possible moves (orthogonal and diagonal)
        let possibleMoves = [
            // Orthogonal moves
            Position(row: currentPosition.row + 1, col: currentPosition.col), // down
            Position(row: currentPosition.row - 1, col: currentPosition.col), // up
            Position(row: currentPosition.row, col: currentPosition.col + 1), // right
            Position(row: currentPosition.row, col: currentPosition.col - 1), // left
            // Diagonal moves
            Position(row: currentPosition.row + 1, col: currentPosition.col + 1), // down-right
            Position(row: currentPosition.row + 1, col: currentPosition.col - 1), // down-left
            Position(row: currentPosition.row - 1, col: currentPosition.col + 1), // up-right
            Position(row: currentPosition.row - 1, col: currentPosition.col - 1)  // up-left
        ]
        
        // Check each possible move
        for pos in possibleMoves {
            // Basic validation
            if !isWithinBounds(pos) {
                continue
            }
            
            // Palace validation
            if !palace.contains(pos.row) {
                continue
            }
            
            // Center columns validation
            if !centerCols.contains(pos.col) {
                continue
            }
            
            // Check if position is occupied by friendly piece
            if isOccupiedBySameColor(pos, board: board) {
                continue
            }
            
            // If we get here, the move is valid
            moves.append(pos)
        }
        
        return moves
    }
} 
