import SwiftUI

class Elephant: Piece {
    init(isRed: Bool, position: Position) {
        let imageName = isRed ? "red_elephant" : "blue_elephant"
        super.init(imageName: imageName, isRed: isRed, position: position)
    }
    
    override func validMoves(board: Board) -> [Position] {
        var moves: [Position] = []
        
        // Elephant moves diagonally 2 steps, with a blocking position in between
        let possibleMoves = [
            // Up-right
            (Position(row: currentPosition.row - 2, col: currentPosition.col + 2),
             Position(row: currentPosition.row - 1, col: currentPosition.col + 1)),
            // Up-left
            (Position(row: currentPosition.row - 2, col: currentPosition.col - 2),
             Position(row: currentPosition.row - 1, col: currentPosition.col - 1)),
            // Down-right
            (Position(row: currentPosition.row + 2, col: currentPosition.col + 2),
             Position(row: currentPosition.row + 1, col: currentPosition.col + 1)),
            // Down-left
            (Position(row: currentPosition.row + 2, col: currentPosition.col - 2),
             Position(row: currentPosition.row + 1, col: currentPosition.col - 1))
        ]
        
        for (targetPos, blockingPos) in possibleMoves {
            if isWithinBounds(targetPos) && isWithinBounds(blockingPos) {
                // Check if the blocking position is empty
                if board.pieceAt(blockingPos) == nil {
                    // Check if target position is empty or contains enemy piece
                    if let piece = board.pieceAt(targetPos) {
                        if piece.isRed != self.isRed {
                            moves.append(targetPos)
                        }
                    } else {
                        moves.append(targetPos)
                    }
                }
            }
        }
        
        return moves
    }
} 
