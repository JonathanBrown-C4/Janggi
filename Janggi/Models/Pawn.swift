import SwiftUI

class Pawn: Piece {
    override var movementRules: [MovementRule] {
        // Pawns have different movement rules based on whether they've crossed the river
        let crossedRiver = isRed ? currentPosition.row > 4 : currentPosition.row < 5
        
        if crossedRiver {
            // After crossing river: can move forward and sideways
            return [
                MovementRule(direction: isRed ? .down : .up, maxDistance: 1), // Forward
                MovementRule(direction: .left, maxDistance: 1), // Sideways
                MovementRule(direction: .right, maxDistance: 1) // Sideways
            ]
        } else {
            // Before crossing river: can only move forward
            return [
                MovementRule(direction: isRed ? .down : .up, maxDistance: 1)
            ]
        }
    }
    
    // Initializer for pawns in their standard starting positions
    init(isRed: Bool, column: Int) {
        let imageName = isRed ? "red_pawn" : "blue_pawn"
        let startingPosition = isRed ? Position(row: 3, col: column) : Position(row: 6, col: column)
        super.init(imageName: imageName, isRed: isRed, position: startingPosition, size: .small)
    }
    
    // Secondary initializer for custom positions (for testing or special scenarios)
    init(isRed: Bool, position: Position) {
        let imageName = isRed ? "red_pawn" : "blue_pawn"
        super.init(imageName: imageName, isRed: isRed, position: position, size: .small)
    }
    
//    override func validMoves(board: Board) -> [Position] {
//        var moves: [Position] = []
//        
//        // Pawns move forward one step, and can move sideways when they cross the river
//        let forward = isRed ? 1 : -1
//        let crossedRiver = isRed ? currentPosition.row > 4 : currentPosition.row < 5
//        
//        // Forward move
//        let forwardPos = Position(row: currentPosition.row + forward, col: currentPosition.col)
//        if isWithinBounds(forwardPos) && !isOccupiedBySameColor(forwardPos, board: board) {
//            moves.append(forwardPos)
//        }
//        
//        // Sideways moves (only after crossing the river)
//        if crossedRiver {
//            let sideMoves = [
//                Position(row: currentPosition.row, col: currentPosition.col + 1),
//                Position(row: currentPosition.row, col: currentPosition.col - 1)
//            ]
//            
//            for pos in sideMoves {
//                if isWithinBounds(pos) && !isOccupiedBySameColor(pos, board: board) {
//                    moves.append(pos)
//                }
//            }
//        }
//        
//        return moves
//    }
} 
