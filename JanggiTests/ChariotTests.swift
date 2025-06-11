import XCTest
@testable import Janggi

final class ChariotTests: BaseJanggiTests {
    func testChariotMovement() {
        // Clear the board first
        for row in 0..<10 {
            for col in 0..<9 {
                board.pieces[row][col] = nil
            }
        }
        
        // Place chariot at initial position
        let initialPos = Position(row: 0, col: 0)
        let chariot = Chariot(isRed: true, position: initialPos)
        board.pieces[initialPos.row][initialPos.col] = chariot
        
        XCTAssertNotNil(board.pieces[initialPos.row][initialPos.col], "Chariot should exist at initial position")
        XCTAssertTrue(board.pieces[initialPos.row][initialPos.col] is Chariot, "Piece at initial position should be a Chariot")
        
        print("Initial Chariot position: \(chariot.currentPosition)")
        print("Chariot is red: \(chariot.isRed)")
        
        // Test valid moves in all directions
        let validMoves = [
            // Right moves
            Position(row: 0, col: 1), // right 1
            Position(row: 0, col: 2), // right 2
            Position(row: 0, col: 3), // right 3
            Position(row: 0, col: 4), // right 4
            Position(row: 0, col: 5), // right 5
            Position(row: 0, col: 6), // right 6
            Position(row: 0, col: 7), // right 7
            Position(row: 0, col: 8), // right 8
            // Down moves
            Position(row: 1, col: 0), // down 1
            Position(row: 2, col: 0), // down 2
            Position(row: 3, col: 0), // down 3
            Position(row: 4, col: 0), // down 4
            Position(row: 5, col: 0), // down 5
            Position(row: 6, col: 0), // down 6
            Position(row: 7, col: 0), // down 7
            Position(row: 8, col: 0), // down 8
            Position(row: 9, col: 0)  // down 9
        ]
        
        let actualMoves = chariot.validMoves(board: board)
        print("Actual valid moves: \(actualMoves)")
        
        // Debug: Print each move and why it's valid/invalid
        for move in validMoves {
            let isWithinBounds = chariot.isWithinBounds(move)
            let isOccupiedBySameColor = chariot.isOccupiedBySameColor(move, board: board)
            let pieceAtPosition = board.pieceAt(move)
            print("Move \(move):")
            print("  - Within bounds: \(isWithinBounds)")
            print("  - Occupied by same color: \(isOccupiedBySameColor)")
            print("  - Piece at position: \(pieceAtPosition?.imageName ?? "none")")
            print("  - Is valid: \(actualMoves.contains(move))")
        }
        
        for move in validMoves {
            XCTAssertTrue(actualMoves.contains(move), "Chariot should be able to move to \(move)")
        }
        
        // Test blocked moves
        let blockingPos = Position(row: 0, col: 1)
        board.pieces[0][1] = Pawn(isRed: true, position: blockingPos)
        let movesWithBlock = chariot.validMoves(board: board)
        print("\nAfter adding blocking pawn at \(blockingPos):")
        print("Valid moves with block: \(movesWithBlock)")
        
        // Test that moves beyond the block are invalid
        let blockedMoves = [
            Position(row: 0, col: 2),
            Position(row: 0, col: 3),
            Position(row: 0, col: 4),
            Position(row: 0, col: 5),
            Position(row: 0, col: 6),
            Position(row: 0, col: 7),
            Position(row: 0, col: 8)
        ]
        
        for move in blockedMoves {
            XCTAssertFalse(movesWithBlock.contains(move), "Chariot should not be able to move to \(move) when blocked")
        }
        
        // Test capture
        let capturePos = Position(row: 0, col: 1)
        board.pieces[0][1] = Pawn(isRed: false, position: capturePos)
        let movesWithCapture = chariot.validMoves(board: board)
        print("\nAfter replacing blocking pawn with enemy pawn:")
        print("Valid moves with capture: \(movesWithCapture)")
        
        XCTAssertTrue(movesWithCapture.contains(capturePos), "Chariot should be able to capture enemy piece")
        
        // Test blocked by multiple pieces
        let secondBlockPos = Position(row: 0, col: 3)
        board.pieces[0][3] = Pawn(isRed: true, position: secondBlockPos)
        let movesWithMultipleBlocks = chariot.validMoves(board: board)
        print("\nAfter adding second blocking pawn at \(secondBlockPos):")
        print("Valid moves with multiple blocks: \(movesWithMultipleBlocks)")
        
        // Test that moves beyond the second block are invalid
        let secondBlockedMoves = [
            Position(row: 0, col: 4),
            Position(row: 0, col: 5),
            Position(row: 0, col: 6),
            Position(row: 0, col: 7),
            Position(row: 0, col: 8)
        ]
        
        for move in secondBlockedMoves {
            XCTAssertFalse(movesWithMultipleBlocks.contains(move), "Chariot should not be able to move to \(move) when blocked by multiple pieces")
        }
    }
} 