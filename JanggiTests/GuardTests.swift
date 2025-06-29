import XCTest
@testable import Janggi

final class GuardTests: XCTestCase {
    var board: Board!
    
    override func setUp() {
        super.setUp()
        board = Board()
        // Clear the board for custom setup
        for row in 0..<10 {
            for col in 0..<9 {
                board.pieces[row][col] = nil
            }
        }
    }
    
    func testOpenMovementInPalace() {
        let guardPiece = Guard(isRed: true, position: Position(row: 1, col: 4))
        board.pieces[1][4] = guardPiece
        let moves = board.validMoves(for: guardPiece)
        let expected = [
            Position(row: 0, col: 4), // up
            Position(row: 2, col: 4), // down
            Position(row: 1, col: 3), // left
            Position(row: 1, col: 5), // right
            Position(row: 0, col: 3), // up-left
            Position(row: 0, col: 5), // up-right
            Position(row: 2, col: 3), // down-left
            Position(row: 2, col: 5)  // down-right
        ]
        for pos in expected {
            XCTAssertTrue(moves.contains(pos), "Guard should be able to move to \(pos)")
        }
        XCTAssertEqual(moves.count, 8, "Guard should have 8 open moves in palace")
    }
    
    func testCannotMoveOutsidePalace() {
        let guardPiece = Guard(isRed: true, position: Position(row: 1, col: 4))
        board.pieces[1][4] = guardPiece
        let moves = board.validMoves(for: guardPiece)
        // Test positions outside palace
        let outsidePalace = [
            Position(row: 3, col: 4), // below palace
            Position(row: 1, col: 2), // outside center columns
            Position(row: 1, col: 6)  // outside center columns
        ]
        for pos in outsidePalace {
            XCTAssertFalse(moves.contains(pos), "Guard should not be able to move to \(pos) outside palace")
        }
    }
    
    func testCaptureEnemy() {
        let guardPiece = Guard(isRed: true, position: Position(row: 1, col: 4))
        board.pieces[1][4] = guardPiece
        // Place enemy at (0,4)
        board.pieces[0][4] = Soldier(isRed: false, position: Position(row: 0, col: 4))
        let moves = board.validMoves(for: guardPiece)
        XCTAssertTrue(moves.contains(Position(row: 0, col: 4)), "Guard should be able to capture enemy at (0,4)")
    }
    
    func testCannotCaptureFriendly() {
        let guardPiece = Guard(isRed: true, position: Position(row: 1, col: 4))
        board.pieces[1][4] = guardPiece
        // Place friendly at (0,4) - a valid move position for the guard
        board.pieces[0][4] = Soldier(isRed: true, position: Position(row: 0, col: 4))
        let moves = board.validMoves(for: guardPiece)
        XCTAssertFalse(moves.contains(Position(row: 0, col: 4)), "Guard should not be able to capture friendly at (0,4)")
    }
    
    func testCanCaptureEnemy() {
        let guardPiece = Guard(isRed: true, position: Position(row: 1, col: 4))
        board.pieces[1][4] = guardPiece
        // Place enemy at (0,4) - a valid move position for the guard
        board.pieces[0][4] = Soldier(isRed: false, position: Position(row: 0, col: 4))
        let moves = board.validMoves(for: guardPiece)
        XCTAssertTrue(moves.contains(Position(row: 0, col: 4)), "Guard should be able to capture enemy at (0,4)")
    }
    
    func testBlueGuardMovement() {
        let guardPiece = Guard(isRed: false, position: Position(row: 8, col: 4))
        board.pieces[8][4] = guardPiece
        let moves = board.validMoves(for: guardPiece)
        // Blue guard should be able to move within blue palace (rows 7-9)
        XCTAssertTrue(moves.contains(Position(row: 7, col: 4)), "Blue guard should move up")
        XCTAssertTrue(moves.contains(Position(row: 9, col: 4)), "Blue guard should move down")
        XCTAssertTrue(moves.contains(Position(row: 8, col: 3)), "Blue guard should move left")
        XCTAssertTrue(moves.contains(Position(row: 8, col: 5)), "Blue guard should move right")
    }
} 
