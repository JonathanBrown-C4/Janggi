import XCTest
@testable import Janggi

final class HorseTests: BaseJanggiTests {
    func testInitialPosition() {
        let initialPos = Position(row: 0, col: 1)
        XCTAssertNotNil(board.pieces[initialPos.row][initialPos.col], "Horse should exist at initial position")
        XCTAssertTrue(board.pieces[initialPos.row][initialPos.col] is Horse, "Piece at initial position should be a Horse")
        
        guard let horse = board.pieces[initialPos.row][initialPos.col] as? Horse else {
            XCTFail("Failed to cast piece to Horse")
            return
        }
        
        XCTAssertTrue(horse.isRed, "Horse should be red")
        XCTAssertEqual(horse.currentPosition, initialPos, "Horse should be at initial position")
    }
    
    func testValidMoves() {
        // Clear the board first
        for row in 0..<10 {
            for col in 0..<9 {
                board.pieces[row][col] = nil
            }
        }
        
        // Place horse at initial position
        let initialPos = Position(row: 4, col: 4) // Center position for maximum possible moves
        let horse = Horse(isRed: true, position: initialPos)
        board.pieces[initialPos.row][initialPos.col] = horse
        
        // Test all possible L-shaped moves
        let validMoves = [
            // Up-right moves
            Position(row: 2, col: 5), // 2 up, 1 right
            Position(row: 3, col: 6), // 1 up, 2 right
            
            // Up-left moves
            Position(row: 2, col: 3), // 2 up, 1 left
            Position(row: 3, col: 2), // 1 up, 2 left
            
            // Down-right moves
            Position(row: 6, col: 5), // 2 down, 1 right
            Position(row: 5, col: 6), // 1 down, 2 right
            
            // Down-left moves
            Position(row: 6, col: 3), // 2 down, 1 left
            Position(row: 5, col: 2)  // 1 down, 2 left
        ]
        
        let actualMoves = horse.validMoves(board: board)
        
        // Debug: Print each move and why it's valid/invalid
        for move in validMoves {
            let isWithinBounds = horse.isWithinBounds(move)
            let isOccupiedBySameColor = horse.isOccupiedBySameColor(move, board: board)
            let pieceAtPosition = board.pieceAt(move)
            print("Move \(move):")
            print("  - Within bounds: \(isWithinBounds)")
            print("  - Occupied by same color: \(isOccupiedBySameColor)")
            print("  - Piece at position: \(pieceAtPosition?.imageName ?? "none")")
            print("  - Is valid: \(actualMoves.contains(move))")
        }
        
        for move in validMoves {
            XCTAssertTrue(actualMoves.contains(move), "Horse should be able to move to \(move)")
        }
    }
    
    func testBlockedMoves() {
        // Clear the board first
        for row in 0..<10 {
            for col in 0..<9 {
                board.pieces[row][col] = nil
            }
        }
        
        // Place horse at initial position
        let initialPos = Position(row: 4, col: 4)
        let horse = Horse(isRed: true, position: initialPos)
        board.pieces[initialPos.row][initialPos.col] = horse
        
        // Test blocking first step
        let firstStepBlock = Position(row: 3, col: 4) // blocks upward movement
        board.pieces[firstStepBlock.row][firstStepBlock.col] = Pawn(isRed: true, position: firstStepBlock)
        
        let blockedMove1 = Position(row: 2, col: 5) // should be blocked
        XCTAssertFalse(horse.canMove(to: blockedMove1, board: board), "Horse should not be able to move when first step is blocked")
        
        // Test blocking second step
        board.pieces[firstStepBlock.row][firstStepBlock.col] = nil // clear first block
        let secondStepBlock = Position(row: 2, col: 5) // blocks the target position
        board.pieces[secondStepBlock.row][secondStepBlock.col] = Pawn(isRed: true, position: secondStepBlock)
        
        XCTAssertFalse(horse.canMove(to: blockedMove1, board: board), "Horse should not be able to move when second step is blocked")
    }
    
    func testInvalidMoves() {
        // Clear the board first
        for row in 0..<10 {
            for col in 0..<9 {
                board.pieces[row][col] = nil
            }
        }
        
        // Place horse at initial position
        let initialPos = Position(row: 4, col: 4)
        let horse = Horse(isRed: true, position: initialPos)
        board.pieces[initialPos.row][initialPos.col] = horse
        
        // Test invalid moves (not L-shaped)
        let invalidMoves = [
            Position(row: 4, col: 6), // straight right
            Position(row: 6, col: 4), // straight down
            Position(row: 4, col: 2), // straight left
            Position(row: 2, col: 4), // straight up
            Position(row: 5, col: 5), // diagonal
            Position(row: 3, col: 3), // diagonal
            Position(row: 5, col: 3), // diagonal
            Position(row: 3, col: 5)  // diagonal
        ]
        
        for move in invalidMoves {
            XCTAssertFalse(horse.canMove(to: move, board: board), "Horse should not be able to move to \(move)")
        }
        
        // Test out of bounds moves
        let outOfBoundsMoves = [
            Position(row: -2, col: 4), // too far up
            Position(row: 11, col: 4), // too far down
            Position(row: 4, col: -2), // too far left
            Position(row: 4, col: 9)   // too far right
        ]
        
        for move in outOfBoundsMoves {
            XCTAssertFalse(horse.canMove(to: move, board: board), "Horse should not be able to move out of bounds to \(move)")
        }
    }
    
    func testCaptureMoves() {
        // Clear the board first
        for row in 0..<10 {
            for col in 0..<9 {
                board.pieces[row][col] = nil
            }
        }
        
        // Place horse at initial position
        let initialPos = Position(row: 4, col: 4)
        let horse = Horse(isRed: true, position: initialPos)
        board.pieces[initialPos.row][initialPos.col] = horse
        
        // Test capturing enemy piece
        let enemyPos = Position(row: 2, col: 5)
        let enemyPiece = Pawn(isRed: false, position: enemyPos)
        board.pieces[enemyPos.row][enemyPos.col] = enemyPiece
        
        XCTAssertTrue(horse.canMove(to: enemyPos, board: board), "Horse should be able to capture enemy piece")
        
        // Test capturing friendly piece (should not be allowed)
        let friendlyPos = Position(row: 6, col: 5)
        let friendlyPiece = Pawn(isRed: true, position: friendlyPos)
        board.pieces[friendlyPos.row][friendlyPos.col] = friendlyPiece
        
        XCTAssertFalse(horse.canMove(to: friendlyPos, board: board), "Horse should not be able to capture friendly piece")
    }
} 