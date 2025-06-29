import SwiftUI

class Cannon: Piece {
    init(isRed: Bool, position: Position) {
        let imageName = isRed ? "red_cannon" : "blue_cannon"
        super.init(imageName: imageName, isRed: isRed, position: position, size: .medium)
    }
    
//    override func validMoves(board: Board) -> [Position] {
//        var moves: [Position] = []
//        
//        // Check moves in all four directions
//        let directions = [
//            (0, 1),  // right
//            (0, -1), // left
//            (1, 0),  // down
//            (-1, 0)  // up
//        ]
//        
//        for (rowDelta, colDelta) in directions {
//            var currentRow = currentPosition.row + rowDelta
//            var currentCol = currentPosition.col + colDelta
//            var foundPlatform = false
//            var platformPos: Position? = nil
//            
//            while isWithinBounds(Position(row: currentRow, col: currentCol)) {
//                let pos = Position(row: currentRow, col: currentCol)
//                
//                if let piece = board.pieceAt(pos) {
//                    if !foundPlatform {
//                        // Found first platform (can be any piece)
//                        foundPlatform = true
//                        platformPos = pos
//                    } else {
//                        // Found another piece after platform
//                        if piece.isRed != self.isRed {
//                            // Can capture enemy piece on opposite side of platform
//                            moves.append(pos)
//                        }
//                        // Stop after finding any piece after platform
//                        break
//                    }
//                } else if foundPlatform {
//                    // Can only move to empty squares after finding platform
//                    // Check if we're on the opposite side of the platform
//                    let isOppositeSide = (rowDelta > 0 && pos.row > platformPos!.row) ||
//                                       (rowDelta < 0 && pos.row < platformPos!.row) ||
//                                       (colDelta > 0 && pos.col > platformPos!.col) ||
//                                       (colDelta < 0 && pos.col < platformPos!.col)
//                    
//                    if isOppositeSide {
//                        moves.append(pos)
//                    }
//                }
//                
//                currentRow += rowDelta
//                currentCol += colDelta
//            }
//        }
//        
//        return moves
//    }
    
    override var movementRules: [MovementRule] {
        return [
            MovementRule(direction: .custom, maxDistance: 0, requiresPlatform: true, palaceRestricted: false, blockingRules: .jumpOver)
        ]
    }
} 
