import XCTest
@testable import Janggi

final class GuardTests: BaseJanggiTests {
    func testGuardMovement() {
        let initialPos = Position(row: 0, col: 3)
        XCTAssertNotNil(board.pieces[initialPos.row][initialPos.col])
        XCTAssertTrue(board.pieces[initialPos.row][initialPos.col] is Guard)
        
        guard let guardPiece = board.pieces[initialPos.row][initialPos.col] as? Guard else {
            XCTFail("Failed to cast piece to Guard")
            return
        }
        
        print("Initial Guard position: \(guardPiece.currentPosition)")
        print("Guard is red: \(guardPiece.isRed)")
        
        // Test valid moves within palace
        let validMoves = [
            Position(row: 0, col: 4), // right
            Position(row: 1, col: 3), // down
            Position(row: 1, col: 4)  // diagonal down-right
        ]
        
        let actualMoves = guardPiece.validMoves(board: board)
        print("Actual valid moves: \(actualMoves)")
        
        // Debug: Print each move and why it's valid/invalid
        for move in validMoves {
            let isWithinBounds = guardPiece.isWithinBounds(move)
            let isInPalace = (0...2).contains(move.row)
            let isInCenterCols = (3...5).contains(move.col)
            let isOccupiedBySameColor = guardPiece.isOccupiedBySameColor(move, board: board)
            let pieceAtPosition = board.pieceAt(move)
            print("Move \(move):")
            print("  - Within bounds: \(isWithinBounds)")
            print("  - In palace: \(isInPalace)")
            print("  - In center cols: \(isInCenterCols)")
            print("  - Occupied by same color: \(isOccupiedBySameColor)")
            print("  - Piece at position: \(pieceAtPosition?.imageName ?? "none")")
            print("  - Is valid: \(actualMoves.contains(move))")
        }
        
        for move in validMoves {
            XCTAssertTrue(actualMoves.contains(move), "Guard should be able to move to \(move)")
        }
        
        // Test invalid moves outside palace or center columns
        let invalidMoves = [
            Position(row: 0, col: 2), // outside center columns
            Position(row: 2, col: 3), // outside palace
            Position(row: 2, col: 4), // outside palace
            Position(row: 2, col: 2)  // outside palace and center columns
        ]
        
        // Debug: Print each invalid move and why it's invalid
        for move in invalidMoves {
            let isWithinBounds = guardPiece.isWithinBounds(move)
            let isInPalace = (0...2).contains(move.row)
            let isInCenterCols = (3...5).contains(move.col)
            let isOccupiedBySameColor = guardPiece.isOccupiedBySameColor(move, board: board)
            let pieceAtPosition = board.pieceAt(move)
            print("Invalid Move \(move):")
            print("  - Within bounds: \(isWithinBounds)")
            print("  - In palace: \(isInPalace)")
            print("  - In center cols: \(isInCenterCols)")
            print("  - Occupied by same color: \(isOccupiedBySameColor)")
            print("  - Piece at position: \(pieceAtPosition?.imageName ?? "none")")
            print("  - Is valid: \(actualMoves.contains(move))")
        }
        
        for move in invalidMoves {
            XCTAssertFalse(actualMoves.contains(move), "Guard should not be able to move to \(move)")
        }
        
        // Test center position moves
        board.pieces[1][4] = guardPiece
        board.pieces[0][3] = nil
        guardPiece.currentPosition = Position(row: 1, col: 4)
        
        print("\nAfter moving Guard to center position:")
        print("New Guard position: \(guardPiece.currentPosition)")
        
        let newMoves = guardPiece.validMoves(board: board)
        print("New valid moves after repositioning: \(newMoves)")
        
        // Verify that the Guard can move to all adjacent positions in the palace
        let expectedNewMoves = [
            Position(row: 1, col: 3), // left
            Position(row: 1, col: 5), // right
            Position(row: 0, col: 4), // up
            Position(row: 2, col: 4), // down
            Position(row: 0, col: 3), // up-left
            Position(row: 0, col: 5), // up-right
            Position(row: 2, col: 3), // down-left
            Position(row: 2, col: 5)  // down-right
        ]
        
        // Debug: Print each move and why it's valid/invalid after repositioning
        for move in expectedNewMoves {
            let isWithinBounds = guardPiece.isWithinBounds(move)
            let isInPalace = (0...2).contains(move.row)
            let isInCenterCols = (3...5).contains(move.col)
            let isOccupiedBySameColor = guardPiece.isOccupiedBySameColor(move, board: board)
            let pieceAtPosition = board.pieceAt(move)
            print("Move \(move):")
            print("  - Within bounds: \(isWithinBounds)")
            print("  - In palace: \(isInPalace)")
            print("  - In center cols: \(isInCenterCols)")
            print("  - Occupied by same color: \(isOccupiedBySameColor)")
            print("  - Piece at position: \(pieceAtPosition?.imageName ?? "none")")
            print("  - Is valid: \(newMoves.contains(move))")
        }
        
        for move in expectedNewMoves {
            XCTAssertTrue(newMoves.contains(move), "Guard should be able to move to \(move) from center position")
        }
    }
} 