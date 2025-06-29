import XCTest
@testable import Janggi

final class GeneralTests: XCTestCase {
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
        let general = General(isRed: true, position: Position(row: 1, col: 4))
        board.pieces[1][4] = general
        let moves = board.validMoves(for: general)
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
            XCTAssertTrue(moves.contains(pos), "General should be able to move to \(pos)")
        }
        XCTAssertEqual(moves.count, 8, "General should have 8 open moves in palace")
    }
    
    func testCannotMoveOutsidePalace() {
        let general = General(isRed: true, position: Position(row: 1, col: 4))
        board.pieces[1][4] = general
        let moves = board.validMoves(for: general)
        // Test positions outside palace
        let outsidePalace = [
            Position(row: 3, col: 4), // below palace
            Position(row: 1, col: 2), // outside center columns
            Position(row: 1, col: 6)  // outside center columns
        ]
        for pos in outsidePalace {
            XCTAssertFalse(moves.contains(pos), "General should not be able to move to \(pos) outside palace")
        }
    }
    
    func testCaptureEnemy() {
        let general = General(isRed: true, position: Position(row: 1, col: 4))
        board.pieces[1][4] = general
        // Place enemy at (0,4)
        board.pieces[0][4] = Soldier(isRed: false, position: Position(row: 0, col: 4))
        let moves = board.validMoves(for: general)
        XCTAssertTrue(moves.contains(Position(row: 0, col: 4)), "General should be able to capture enemy at (0,4)")
    }
    
    func testCannotCaptureFriendly() {
        let general = General(isRed: true, position: Position(row: 1, col: 4))
        board.pieces[1][4] = general
        // Place friendly at (0,4) - a valid move position for the general
        board.pieces[0][4] = Soldier(isRed: true, position: Position(row: 0, col: 4))
        let moves = board.validMoves(for: general)
        XCTAssertFalse(moves.contains(Position(row: 0, col: 4)), "General should not be able to capture friendly at (0,4)")
    }
    
    func testCanCaptureEnemy() {
        let general = General(isRed: true, position: Position(row: 1, col: 4))
        board.pieces[1][4] = general
        // Place enemy at (0,4) - a valid move position for the general
        board.pieces[0][4] = Soldier(isRed: false, position: Position(row: 0, col: 4))
        let moves = board.validMoves(for: general)
        XCTAssertTrue(moves.contains(Position(row: 0, col: 4)), "General should be able to capture enemy at (0,4)")
    }
    
    func testBlueGeneralMovement() {
        let general = General(isRed: false, position: Position(row: 8, col: 4))
        board.pieces[8][4] = general
        let moves = board.validMoves(for: general)
        // Blue general should be able to move within blue palace (rows 7-9)
        XCTAssertTrue(moves.contains(Position(row: 7, col: 4)), "Blue general should move up")
        XCTAssertTrue(moves.contains(Position(row: 9, col: 4)), "Blue general should move down")
        XCTAssertTrue(moves.contains(Position(row: 8, col: 3)), "Blue general should move left")
        XCTAssertTrue(moves.contains(Position(row: 8, col: 5)), "Blue general should move right")
    }
    
    func testGeneralAtCorner() {
        let general = General(isRed: true, position: Position(row: 0, col: 3))
        board.pieces[0][3] = general
        let moves = board.validMoves(for: general)
        // From corner (0,3), should only have 3 moves (down, down-right, right)
        XCTAssertTrue(moves.contains(Position(row: 1, col: 3)), "General should move down from corner")
        XCTAssertTrue(moves.contains(Position(row: 1, col: 4)), "General should move down-right from corner")
        XCTAssertTrue(moves.contains(Position(row: 0, col: 4)), "General should move right from corner")
        XCTAssertEqual(moves.count, 3, "General should have 3 moves from corner")
    }
} 