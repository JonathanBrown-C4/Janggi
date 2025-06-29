import XCTest
@testable import Janggi

final class HorseTests: XCTestCase {
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
        let horse = Horse(isRed: true, position: Position(row: 4, col: 4))
        board.pieces[4][4] = horse
        let moves = board.validMoves(for: horse)
        let expected = [
            Position(row: 2, col: 5), Position(row: 2, col: 3),
            Position(row: 6, col: 5), Position(row: 6, col: 3),
            Position(row: 3, col: 6), Position(row: 5, col: 6),
            Position(row: 3, col: 2), Position(row: 5, col: 2)
        ]
        for pos in expected {
            XCTAssertTrue(moves.contains(pos), "Horse should be able to move to \(pos)")
        }
        XCTAssertEqual(moves.count, 8, "Horse should have 8 open moves")
    }
    
    func testBlockedByFirstStep() {
        let horse = Horse(isRed: true, position: Position(row: 4, col: 4))
        board.pieces[4][4] = horse
        // Block up direction
        board.pieces[3][4] = Soldier(isRed: true, position: Position(row: 3, col: 4))
        let moves = board.validMoves(for: horse)
        // Up-2 moves should be blocked
        XCTAssertFalse(moves.contains(Position(row: 2, col: 5)), "Horse should not move to (2,5) if up blocked")
        XCTAssertFalse(moves.contains(Position(row: 2, col: 3)), "Horse should not move to (2,3) if up blocked")
    }
    
    func testBlockedBySecondStep() {
        let horse = Horse(isRed: true, position: Position(row: 4, col: 4))
        board.pieces[4][4] = horse
        // Block right direction
        board.pieces[4][5] = Soldier(isRed: true, position: Position(row: 4, col: 5))
        let moves = board.validMoves(for: horse)
        // Right-2 moves should be blocked
        XCTAssertFalse(moves.contains(Position(row: 3, col: 6)), "Horse should not move to (3,6) if right blocked")
        XCTAssertFalse(moves.contains(Position(row: 5, col: 6)), "Horse should not move to (5,6) if right blocked")
    }
    
    func testBlockedByCenter() {
        let horse = Horse(isRed: true, position: Position(row: 4, col: 4))
        board.pieces[4][4] = horse
        // Block up-right direction
        board.pieces[3][4] = Soldier(isRed: true, position: Position(row: 3, col: 4))
        let moves = board.validMoves(for: horse)
        // Up-right move should be blocked
        XCTAssertFalse(moves.contains(Position(row: 2, col: 6)), "Horse should not move to (2,6) if center blocked")
    }
    
    func testBlockedByEnd() {
        let horse = Horse(isRed: true, position: Position(row: 4, col: 4))
        board.pieces[4][4] = horse
        // Block up-right direction at end
        board.pieces[4][5] = Soldier(isRed: true, position: Position(row: 4, col: 5))
        let moves = board.validMoves(for: horse)
        // Up-right move should be blocked
        XCTAssertFalse(moves.contains(Position(row: 2, col: 6)), "Horse should not move to (2,6) if end blocked")
    }
    
    func testCaptureEnemy() {
        let horse = Horse(isRed: true, position: Position(row: 4, col: 5))
        board.pieces[4][5] = horse
        // Place enemy at (2,6) - a valid Horse move from (4,5)
        board.pieces[2][6] = Soldier(isRed: false, position: Position(row: 2, col: 6))
        let moves = board.validMoves(for: horse)
        XCTAssertTrue(moves.contains(Position(row: 2, col: 6)), "Horse should be able to capture enemy at (2,6)")
    }
    
    func testCannotCaptureFriendly() {
        let horse = Horse(isRed: true, position: Position(row: 4, col: 4))
        board.pieces[4][4] = horse
        // Place friendly at (2,6)
        board.pieces[2][6] = Soldier(isRed: true, position: Position(row: 2, col: 6))
        let moves = board.validMoves(for: horse)
        XCTAssertFalse(moves.contains(Position(row: 2, col: 6)), "Horse should not be able to capture friendly at (2,6)")
    }
} 