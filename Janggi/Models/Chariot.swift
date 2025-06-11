import SwiftUI

class Chariot: Piece {
    init(isRed: Bool, position: Position) {
        let imageName = isRed ? "red_chariot" : "blue_chariot"
        super.init(imageName: imageName, isRed: isRed, position: position, size:.medium)
    }
    
    override func validMoves(board: Board) -> [Position] {
        var moves: [Position] = []
        
        // Check moves in all four directions
        let directions = [
            (0, 1),  // right
            (0, -1), // left
            (1, 0),  // down
            (-1, 0)  // up
        ]
        
        for (rowDelta, colDelta) in directions {
            var currentRow = currentPosition.row + rowDelta
            var currentCol = currentPosition.col + colDelta
            
            while isWithinBounds(Position(row: currentRow, col: currentCol)) {
                let pos = Position(row: currentRow, col: currentCol)
                if let piece = board.pieceAt(pos) {
                    if piece.isRed != self.isRed {
                        moves.append(pos)
                    }
                    break
                }
                moves.append(pos)
                currentRow += rowDelta
                currentCol += colDelta
            }
        }
        
        // Debug logging
        print("Chariot at (\(currentPosition.row), \(currentPosition.col)) valid moves: \(moves)")
        return moves
    }
    
    override func canMove(to position: Position, board: Board) -> Bool {
        // Check if position is within bounds
        guard isWithinBounds(position) else { return false }
        
        // Check if position is occupied by friendly piece
        if isOccupiedBySameColor(position, board: board) {
            return false
        }
        
        // Check if the move is in a straight line (horizontal or vertical)
        if position.row != currentPosition.row && position.col != currentPosition.col {
            return false
        }
        
        // Check if there are any pieces between current position and target position
        let rowDelta = position.row - currentPosition.row
        let colDelta = position.col - currentPosition.col
        
        // Determine step size and direction
        let rowStep = rowDelta == 0 ? 0 : rowDelta / abs(rowDelta)
        let colStep = colDelta == 0 ? 0 : colDelta / abs(colDelta)
        
        // Check each position between current and target
        var currentRow = currentPosition.row + rowStep
        var currentCol = currentPosition.col + colStep
        
        while currentRow != position.row || currentCol != position.col {
            if board.pieceAt(Position(row: currentRow, col: currentCol)) != nil {
                return false // Found a piece in the way
            }
            currentRow += rowStep
            currentCol += colStep
        }
        
        return true
    }
} 
