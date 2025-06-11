import SwiftUI

class Pawn: Piece {
    init(isRed: Bool, position: Position) {
        let imageName = isRed ? "red_pawn" : "blue_pawn"
        super.init(imageName: imageName, isRed: isRed, position: position, size: .small)
    }
    
    override func validMoves(board: Board) -> [Position] {
        var moves: [Position] = []
        
        // Pawns move forward one step, and can move sideways when they cross the river
        let forward = isRed ? 1 : -1
        let crossedRiver = isRed ? currentPosition.row > 4 : currentPosition.row < 5
        
        // Forward move
        let forwardPos = Position(row: currentPosition.row + forward, col: currentPosition.col)
        if isWithinBounds(forwardPos) && !isOccupiedBySameColor(forwardPos, board: board) {
            moves.append(forwardPos)
        }
        
        // Sideways moves (only after crossing the river)
        if crossedRiver {
            let sideMoves = [
                Position(row: currentPosition.row, col: currentPosition.col + 1),
                Position(row: currentPosition.row, col: currentPosition.col - 1)
            ]
            
            for pos in sideMoves {
                if isWithinBounds(pos) && !isOccupiedBySameColor(pos, board: board) {
                    moves.append(pos)
                }
            }
        }
        
        return moves
    }
} 
