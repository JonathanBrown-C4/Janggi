import XCTest
@testable import Janggi

final class ElephantTests: BaseJanggiTests {
    func testElephantMovement() {
        let initialPos = Position(row: 0, col: 2)
        XCTAssertNotNil(board.pieces[initialPos.row][initialPos.col])
        XCTAssertTrue(board.pieces[initialPos.row][initialPos.col] is Elephant)
        
        // Test valid moves
        let validMoves = [
            Position(row: 2, col: 0), // diagonal down-left
            Position(row: 2, col: 4)  // diagonal down-right
        ]
        
        for move in validMoves {
            XCTAssertTrue(board.pieces[initialPos.row][initialPos.col]?.canMove(to: move, board: board) ?? false, "Elephant should be able to move to \(move)")
        }
        
        // Test blocked moves
        let blockingPos = Position(row: 1, col: 1)
        board.pieces[1][1] = Pawn(isRed: true, position: blockingPos)
        XCTAssertFalse(board.pieces[initialPos.row][initialPos.col]?.canMove(to: Position(row: 2, col: 0), board: board) ?? false, "Elephant should not be able to move when blocked")
        
        // Test other diagonal moves
        let otherBlockingPos = Position(row: 1, col: 3)
        board.pieces[1][3] = Pawn(isRed: true, position: otherBlockingPos)
        XCTAssertFalse(board.pieces[initialPos.row][initialPos.col]?.canMove(to: Position(row: 2, col: 4), board: board) ?? false, "Elephant should not be able to move when blocked")
    }
} 