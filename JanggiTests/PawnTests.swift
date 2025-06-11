import XCTest
@testable import Janggi

final class PawnTests: BaseJanggiTests {
    func testPawnMovement() {
        // Test initial position
        let initialPos = Position(row: 3, col: 0)
        XCTAssertNotNil(board.pieces[initialPos.row][initialPos.col], "Pawn should exist at initial position")
        XCTAssertTrue(board.pieces[initialPos.row][initialPos.col] is Pawn, "Piece at initial position should be a Pawn")
        
        guard let pawn = board.pieces[initialPos.row][initialPos.col] as? Pawn else {
            XCTFail("Failed to cast piece to Pawn")
            return
        }
        
        print("Initial Pawn position: \(pawn.currentPosition)")
        print("Pawn is red: \(pawn.isRed)")
        
        // Test valid moves before crossing the river
        let validMovesBeforeRiver = [
            Position(row: 4, col: 0)  // forward
        ]
        
        let actualMoves = pawn.validMoves(board: board)
        print("Actual valid moves: \(actualMoves)")
        
        for move in validMovesBeforeRiver {
            XCTAssertTrue(actualMoves.contains(move), "Pawn should be able to move forward to \(move)")
        }
        
        // Test invalid moves before crossing the river
        let invalidMovesBeforeRiver = [
            Position(row: 3, col: 1), // right
            Position(row: 3, col: -1), // left
            Position(row: 2, col: 0), // backward
            Position(row: 4, col: 1)  // diagonal
        ]
        
        for move in invalidMovesBeforeRiver {
            XCTAssertFalse(actualMoves.contains(move), "Pawn should not be able to move to \(move) before crossing river")
        }
        
        // Move pawn across the river
        board.pieces[5][0] = pawn
        board.pieces[3][0] = nil
        pawn.currentPosition = Position(row: 5, col: 0)
        
        print("\nAfter moving Pawn across river:")
        print("New Pawn position: \(pawn.currentPosition)")
        
        // Test valid moves after crossing the river
        let validMovesAfterRiver = [
            Position(row: 6, col: 0), // forward
            Position(row: 5, col: 1)  // right
        ]
        
        let newMoves = pawn.validMoves(board: board)
        print("New valid moves after crossing river: \(newMoves)")
        
        for move in validMovesAfterRiver {
            XCTAssertTrue(newMoves.contains(move), "Pawn should be able to move to \(move) after crossing river")
        }
        
        // Test capture
        let capturePos = Position(row: 6, col: 0)
        board.pieces[6][0] = Pawn(isRed: false, position: capturePos)
        let movesWithCapture = pawn.validMoves(board: board)
        XCTAssertTrue(movesWithCapture.contains(capturePos), "Pawn should be able to capture enemy piece")
        
        // Test blocked by friendly piece
        let friendlyPos = Position(row: 5, col: 1)
        board.pieces[5][1] = Pawn(isRed: true, position: friendlyPos)
        let movesWithBlock = pawn.validMoves(board: board)
        XCTAssertFalse(movesWithBlock.contains(friendlyPos), "Pawn should not be able to move to position occupied by friendly piece")
    }
    
    private func isWithinBounds(_ position: Position) -> Bool {
        return position.row >= 0 && position.row < 10 && position.col >= 0 && position.col < 9
    }
} 