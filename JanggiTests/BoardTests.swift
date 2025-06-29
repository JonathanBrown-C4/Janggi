import XCTest
@testable import Janggi

final class BoardTests: XCTestCase {
    var board: Board!
    
    override func setUp() {
        super.setUp()
        board = Board()
        // Clear the board and set up only Chariots and Soldiers for testing
        for row in 0..<10 {
            for col in 0..<9 {
                board.pieces[row][col] = nil
            }
        }
    }
    
    override func tearDown() {
        board = nil
        super.tearDown()
    }
    
    func testBoardInitialization() {
        // Test that board is properly initialized
        XCTAssertNotNil(board, "Board should be initialized")
        XCTAssertEqual(board.pieces.count, 10, "Board should have 10 rows")
        XCTAssertEqual(board.pieces[0].count, 9, "Board should have 9 columns")
    }
    
    func testPlacePiece() {
        let chariot = Chariot(isRed: true, position: Position(row: 0, col: 0))
        board.pieces[0][0] = chariot
        XCTAssertNotNil(board.pieces[0][0], "Chariot should be placed at (0,0)")
        XCTAssertEqual(board.pieces[0][0]?.type, .chariot, "Piece at (0,0) should be a chariot")
    }
    
    func testSetupSoldiers() {
        // Set up some Soldiers for validation
        board.pieces[3][0] = Soldier(isRed: true, column: 0)   // Red soldier
        board.pieces[6][0] = Soldier(isRed: false, column: 0)  // Blue soldier
        
        XCTAssertNotNil(board.pieces[3][0], "Red soldier should be at (3,0)")
        XCTAssertNotNil(board.pieces[6][0], "Blue soldier should be at (6,0)")
        XCTAssertEqual(board.pieces[3][0]?.type, .soldier, "Piece at (3,0) should be a soldier")
        XCTAssertEqual(board.pieces[6][0]?.type, .soldier, "Piece at (6,0) should be a soldier")
    }
    
    func testChariotOpenMovement() {
        let chariot = Chariot(isRed: true, position: Position(row: 0, col: 0))
        board.pieces[0][0] = chariot
        let moves = board.validMoves(for: chariot)
        
        // Should be able to move down the entire column
        XCTAssertTrue(moves.contains(Position(row: 1, col: 0)), "Chariot should move down to (1,0)")
        XCTAssertTrue(moves.contains(Position(row: 2, col: 0)), "Chariot should move down to (2,0)")
        XCTAssertTrue(moves.contains(Position(row: 3, col: 0)), "Chariot should move down to (3,0)")
        XCTAssertTrue(moves.contains(Position(row: 4, col: 0)), "Chariot should move down to (4,0)")
        XCTAssertTrue(moves.contains(Position(row: 5, col: 0)), "Chariot should move down to (5,0)")
        XCTAssertTrue(moves.contains(Position(row: 6, col: 0)), "Chariot should move down to (6,0)")
        XCTAssertTrue(moves.contains(Position(row: 7, col: 0)), "Chariot should move down to (7,0)")
        XCTAssertTrue(moves.contains(Position(row: 8, col: 0)), "Chariot should move down to (8,0)")
        XCTAssertTrue(moves.contains(Position(row: 9, col: 0)), "Chariot should move down to (9,0)")
        
        // Should be able to move right across the entire row
        XCTAssertTrue(moves.contains(Position(row: 0, col: 1)), "Chariot should move right to (0,1)")
        XCTAssertTrue(moves.contains(Position(row: 0, col: 2)), "Chariot should move right to (0,2)")
        XCTAssertTrue(moves.contains(Position(row: 0, col: 3)), "Chariot should move right to (0,3)")
        XCTAssertTrue(moves.contains(Position(row: 0, col: 4)), "Chariot should move right to (0,4)")
        XCTAssertTrue(moves.contains(Position(row: 0, col: 5)), "Chariot should move right to (0,5)")
        XCTAssertTrue(moves.contains(Position(row: 0, col: 6)), "Chariot should move right to (0,6)")
        XCTAssertTrue(moves.contains(Position(row: 0, col: 7)), "Chariot should move right to (0,7)")
        XCTAssertTrue(moves.contains(Position(row: 0, col: 8)), "Chariot should move right to (0,8)")
    }
    
    func testChariotBlockedBySoldier() {
        let chariot = Chariot(isRed: true, position: Position(row: 0, col: 0))
        board.pieces[0][0] = chariot
        
        // Add a red soldier to block the chariot's downward movement
        board.pieces[2][0] = Soldier(isRed: true, position: Position(row: 2, col: 0))
        
        let moves = board.validMoves(for: chariot)
        
        // Should not be able to move past the blocking soldier
        XCTAssertFalse(moves.contains(Position(row: 3, col: 0)), "Chariot should not move past blocking soldier")
        XCTAssertFalse(moves.contains(Position(row: 4, col: 0)), "Chariot should not move past blocking soldier")
        
        // Should NOT be able to move to the position of the blocking soldier (same color)
        XCTAssertFalse(moves.contains(Position(row: 2, col: 0)), "Chariot should not be able to capture same-color soldier")
    }
    
    func testChariotCaptureEnemySoldier() {
        let chariot = Chariot(isRed: true, position: Position(row: 0, col: 0))
        board.pieces[0][0] = chariot
        
        // Add an enemy soldier to block the chariot's downward movement
        board.pieces[2][0] = Soldier(isRed: false, position: Position(row: 2, col: 0))
        
        let moves = board.validMoves(for: chariot)
        
        // Should be able to capture the enemy soldier
        XCTAssertTrue(moves.contains(Position(row: 2, col: 0)), "Chariot should be able to capture enemy soldier")
        
        // Should not be able to move past the enemy soldier
        XCTAssertFalse(moves.contains(Position(row: 3, col: 0)), "Chariot should not move past enemy soldier")
    }
    
    func testChariotHorizontalMovement() {
        let chariot = Chariot(isRed: true, position: Position(row: 5, col: 4))
        board.pieces[5][4] = chariot
        
        let moves = board.validMoves(for: chariot)
        
        // Should be able to move left and right
        XCTAssertTrue(moves.contains(Position(row: 5, col: 0)), "Chariot should move left to (5,0)")
        XCTAssertTrue(moves.contains(Position(row: 5, col: 1)), "Chariot should move left to (5,1)")
        XCTAssertTrue(moves.contains(Position(row: 5, col: 2)), "Chariot should move left to (5,2)")
        XCTAssertTrue(moves.contains(Position(row: 5, col: 3)), "Chariot should move left to (5,3)")
        XCTAssertTrue(moves.contains(Position(row: 5, col: 5)), "Chariot should move right to (5,5)")
        XCTAssertTrue(moves.contains(Position(row: 5, col: 6)), "Chariot should move right to (5,6)")
        XCTAssertTrue(moves.contains(Position(row: 5, col: 7)), "Chariot should move right to (5,7)")
        XCTAssertTrue(moves.contains(Position(row: 5, col: 8)), "Chariot should move right to (5,8)")
    }
    
    func testChariotAfterSoldierMoves() {
        let chariot = Chariot(isRed: true, position: Position(row: 0, col: 0))
        board.pieces[0][0] = chariot
        
        // Remove the red soldier that's blocking the chariot
        board.pieces[3][0] = nil
        
        // Move the blue soldier (enemy) down to open up space for the chariot
        let blueSoldier = board.pieces[6][0] as! Soldier
        board.pieces[6][0] = nil
        board.pieces[4][0] = blueSoldier
        blueSoldier.currentPosition = Position(row: 4, col: 0)
        
        let moves = board.validMoves(for: chariot)
        
        // Should now be able to move down to row 3
        XCTAssertTrue(moves.contains(Position(row: 3, col: 0)), "Chariot should move down after soldier moves")
        
        // Should also be able to move to row 4 (capture the enemy soldier)
        XCTAssertTrue(moves.contains(Position(row: 4, col: 0)), "Chariot should be able to capture enemy soldier")
    }
} 