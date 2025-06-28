import SwiftUI

class Horse: Piece {
    init(isRed: Bool, position: Position) {
        let imageName = isRed ? "red_horse" : "blue_horse"
        super.init(imageName: imageName, isRed: isRed, position: position, size: .medium)
    }
    
//    override func validMoves(board: Board) -> [Position] {
//        var moves: [Position] = []
//        
//        // Horse moves in an L-shape: 2 steps in one direction, then 1 step perpendicular
//        let possibleMoves = [
//            // Up-right
//            (Position(row: currentPosition.row - 2, col: currentPosition.col + 1),
//             Position(row: currentPosition.row - 1, col: currentPosition.col),
//             Position(row: currentPosition.row - 2, col: currentPosition.col)),
//            // Up-left
//            (Position(row: currentPosition.row - 2, col: currentPosition.col - 1),
//             Position(row: currentPosition.row - 1, col: currentPosition.col),
//             Position(row: currentPosition.row - 2, col: currentPosition.col)),
//            // Right-up
//            (Position(row: currentPosition.row - 1, col: currentPosition.col + 2),
//             Position(row: currentPosition.row, col: currentPosition.col + 1),
//             Position(row: currentPosition.row, col: currentPosition.col + 2)),
//            // Right-down
//            (Position(row: currentPosition.row + 1, col: currentPosition.col + 2),
//             Position(row: currentPosition.row, col: currentPosition.col + 1),
//             Position(row: currentPosition.row, col: currentPosition.col + 2)),
//            // Down-right
//            (Position(row: currentPosition.row + 2, col: currentPosition.col + 1),
//             Position(row: currentPosition.row + 1, col: currentPosition.col),
//             Position(row: currentPosition.row + 2, col: currentPosition.col)),
//            // Down-left
//            (Position(row: currentPosition.row + 2, col: currentPosition.col - 1),
//             Position(row: currentPosition.row + 1, col: currentPosition.col),
//             Position(row: currentPosition.row + 2, col: currentPosition.col)),
//            // Left-down
//            (Position(row: currentPosition.row + 1, col: currentPosition.col - 2),
//             Position(row: currentPosition.row, col: currentPosition.col - 1),
//             Position(row: currentPosition.row, col: currentPosition.col - 2)),
//            // Left-up
//            (Position(row: currentPosition.row - 1, col: currentPosition.col - 2),
//             Position(row: currentPosition.row, col: currentPosition.col - 1),
//             Position(row: currentPosition.row, col: currentPosition.col - 2))
//        ]
//        
//        for (targetPos, blockingPos1, blockingPos2) in possibleMoves {
//            if isWithinBounds(targetPos) && isWithinBounds(blockingPos1) && isWithinBounds(blockingPos2) {
//                // Check if both blocking positions are empty
//                if board.pieceAt(blockingPos1) == nil && board.pieceAt(blockingPos2) == nil {
//                    // Check if target position is empty or contains enemy piece
//                    if let piece = board.pieceAt(targetPos) {
//                        if piece.isRed != self.isRed {
//                            moves.append(targetPos)
//                        }
//                    } else {
//                        moves.append(targetPos)
//                    }
//                }
//            }
//        }
//        
//        return moves
//    }
} 
