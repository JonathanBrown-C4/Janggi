import SwiftUI

class Guard: Piece {
    init(isRed: Bool, position: Position) {
        let imageName = isRed ? "red_guard" : "blue_guard"
        super.init(imageName: imageName, isRed: isRed, position: position, size: .small)
    }
    
//    override func validMoves(board: Board) -> [Position] {
//        var moves: [Position] = []
//        let currentRow = currentPosition.row
//        let currentCol = currentPosition.col
//        
//        // Define all possible moves (orthogonal and diagonal)
//        let possibleMoves = [
//            Position(row: currentRow - 1, col: currentCol),     // up
//            Position(row: currentRow + 1, col: currentCol),     // down
//            Position(row: currentRow, col: currentCol - 1),     // left
//            Position(row: currentRow, col: currentCol + 1),     // right
//            Position(row: currentRow - 1, col: currentCol - 1), // up-left
//            Position(row: currentRow - 1, col: currentCol + 1), // up-right
//            Position(row: currentRow + 1, col: currentCol - 1), // down-left
//            Position(row: currentRow + 1, col: currentCol + 1)  // down-right
//        ]
//        
//        for move in possibleMoves {
//            // Check if move is within bounds
//            guard isWithinBounds(move) else { continue }
//            
//            // Check if move is within palace
//            guard (0...2).contains(move.row) else { continue }
//            
//            // Check if move is within center columns
//            guard (3...5).contains(move.col) else { continue }
//            
//            // Check if move is occupied by an enemy piece
//            if let piece = board.pieceAt(move), piece.isRed != isRed {
//                continue
//            }
//            
//            moves.append(move)
//        }
//        
//        return moves
//    }
} 
