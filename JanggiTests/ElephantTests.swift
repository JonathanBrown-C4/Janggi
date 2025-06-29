import XCTest
@testable import Janggi

final class ElephantTests: XCTestCase {
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
    
    func testOpenMovement() {
        let elephant = Elephant(isRed: true, position: Position(row: 4, col: 4))
        board.pieces[4][4] = elephant
        let moves = board.validMoves(for: elephant)
        let expected = [
            Position(row: 2, col: 6), // Up-right
            Position(row: 2, col: 2), // Up-left
            Position(row: 6, col: 6), // Down-right
            Position(row: 6, col: 2)  // Down-left
        ]
        for pos in expected {
            XCTAssertTrue(moves.contains(pos), "Elephant should be able to move to \(pos)")
        }
        XCTAssertEqual(moves.count, 4, "Elephant should have 4 open moves")
    }
    
    func testBlockedByCenter() {
        let elephant = Elephant(isRed: true, position: Position(row: 4, col: 4))
        board.pieces[4][4] = elephant
        // Block up-right direction
        board.pieces[3][5] = Soldier(isRed: true, position: Position(row: 3, col: 5))
        let moves = board.validMoves(for: elephant)
        // Up-right move should be blocked
        XCTAssertFalse(moves.contains(Position(row: 2, col: 6)), "Elephant should not move to (2,6) if center blocked")
    }
    
    func testCaptureEnemy() {
        let elephant = Elephant(isRed: true, position: Position(row: 4, col: 4))
        board.pieces[4][4] = elephant
        // Place enemy at (2,6)
        board.pieces[2][6] = Soldier(isRed: false, position: Position(row: 2, col: 6))
        let moves = board.validMoves(for: elephant)
        XCTAssertTrue(moves.contains(Position(row: 2, col: 6)), "Elephant should be able to capture enemy at (2,6)")
    }
    
    func testCannotCaptureFriendly() {
        let elephant = Elephant(isRed: true, position: Position(row: 4, col: 4))
        board.pieces[4][4] = elephant
        // Place friendly at (2,6)
        board.pieces[2][6] = Soldier(isRed: true, position: Position(row: 2, col: 6))
        let moves = board.validMoves(for: elephant)
        XCTAssertFalse(moves.contains(Position(row: 2, col: 6)), "Elephant should not be able to capture friendly at (2,6)")
    }
    
    func testCannotMoveWhenBlocked() {
        let elephant = Elephant(isRed: true, position: Position(row: 4, col: 4))
        board.pieces[4][4] = elephant
        // Block all directions
        board.pieces[3][5] = Soldier(isRed: true, position: Position(row: 3, col: 5)) // Up-right
        board.pieces[3][3] = Soldier(isRed: true, position: Position(row: 3, col: 3)) // Up-left
        board.pieces[5][5] = Soldier(isRed: true, position: Position(row: 5, col: 5)) // Down-right
        board.pieces[5][3] = Soldier(isRed: true, position: Position(row: 5, col: 3)) // Down-left
        let moves = board.validMoves(for: elephant)
        XCTAssertEqual(moves.count, 0, "Elephant should have no moves when all directions are blocked")
    }
} 