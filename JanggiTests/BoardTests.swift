import XCTest
@testable import Janggi

final class BoardTests: XCTestCase {
    var board: Board!
    
    override func setUp() {
        super.setUp()
        board = Board()
        // Clear the board and set up only Chariots and Pawns for testing
        setupTestBoard()
    }
    
    override func tearDown() {
        board = nil
        super.tearDown()
    }
    
    private func setupTestBoard() {
        // Clear the board
        for row in 0..<10 {
            for col in 0..<9 {
                board.pieces[row][col] = nil
            }
        }
        
        // Set up Chariots at their starting positions
        board.pieces[0][0] = Chariot(isRed: true, isLeft: true)  // Red left chariot
        board.pieces[0][8] = Chariot(isRed: true, isLeft: false) // Red right chariot
        board.pieces[9][0] = Chariot(isRed: false, isLeft: true) // Blue left chariot
        board.pieces[9][8] = Chariot(isRed: false, isLeft: false) // Blue right chariot
        
        // Set up some Pawns for validation
        board.pieces[3][0] = Pawn(isRed: true, column: 0)   // Red pawn
        board.pieces[6][0] = Pawn(isRed: false, column: 0)  // Blue pawn
    }
    
    func testBoardInitialization() {
        // Test board dimensions
        XCTAssertEqual(board.pieces.count, 10, "Board should have 10 rows")
        XCTAssertEqual(board.pieces[0].count, 9, "Board should have 9 columns")
        
        // Test initial piece placement
        XCTAssertNotNil(board.pieces[0][0], "Red left chariot should be at (0,0)")
        XCTAssertNotNil(board.pieces[0][8], "Red right chariot should be at (0,8)")
        XCTAssertNotNil(board.pieces[9][0], "Blue left chariot should be at (9,0)")
        XCTAssertNotNil(board.pieces[9][8], "Blue right chariot should be at (9,8)")
        XCTAssertNotNil(board.pieces[3][0], "Red pawn should be at (3,0)")
        XCTAssertNotNil(board.pieces[6][0], "Blue pawn should be at (6,0)")
        
        // Test initial game state
        XCTAssertTrue(board.isRedTurn, "Red should start first")
        XCTAssertEqual(board.gameState, .playing, "Game should start in playing state")
    }
    
    func testChariotOpenMovement() {
        let redChariot = board.pieces[0][0] as! Chariot
        let moves = board.validMoves(for: redChariot)
        
        // Should be able to move right along the top row
        XCTAssertTrue(moves.contains(Position(row: 0, col: 1)), "Chariot should move right")
        XCTAssertTrue(moves.contains(Position(row: 0, col: 2)), "Chariot should move right")
        XCTAssertTrue(moves.contains(Position(row: 0, col: 7)), "Chariot should move right")
        
        // Should be able to move down along the left column
        XCTAssertTrue(moves.contains(Position(row: 1, col: 0)), "Chariot should move down")
        XCTAssertTrue(moves.contains(Position(row: 2, col: 0)), "Chariot should move down")
        XCTAssertTrue(moves.contains(Position(row: 2, col: 0)), "Chariot should move down")
        
        // Should not be able to move beyond board boundaries
        XCTAssertFalse(moves.contains(Position(row: -1, col: 0)), "Chariot should not move above board")
        XCTAssertFalse(moves.contains(Position(row: 0, col: -1)), "Chariot should not move left of board")
    }
    
    func testChariotBlockedByPawn() {
        let redChariot = board.pieces[0][0] as! Chariot
        
        // Add a red pawn to block the chariot's downward movement
        board.pieces[2][0] = Pawn(isRed: true, position: Position(row: 2, col: 0))
        
        let moves = board.validMoves(for: redChariot)
        
        // Should not be able to move past the blocking pawn
        XCTAssertFalse(moves.contains(Position(row: 3, col: 0)), "Chariot should not move past blocking pawn")
        XCTAssertFalse(moves.contains(Position(row: 4, col: 0)), "Chariot should not move past blocking pawn")
        
        // Should NOT be able to move to the position of the blocking pawn (same color)
        XCTAssertFalse(moves.contains(Position(row: 2, col: 0)), "Chariot should not be able to capture same-color pawn")
    }
    
    func testChariotCaptureEnemyPawn() {
        let redChariot = board.pieces[0][0] as! Chariot
        
        // Add an enemy pawn to block the chariot's downward movement
        board.pieces[2][0] = Pawn(isRed: false, position: Position(row: 2, col: 0))
        
        let moves = board.validMoves(for: redChariot)
        
        // Should be able to capture the enemy pawn
        XCTAssertTrue(moves.contains(Position(row: 2, col: 0)), "Chariot should be able to capture enemy pawn")
        
        // Should not be able to move past the enemy pawn
        XCTAssertFalse(moves.contains(Position(row: 3, col: 0)), "Chariot should not move past enemy pawn")
    }
    
    func testChariotMovementFromDifferentPositions() {
        // Test red right chariot
        let redRightChariot = board.pieces[0][8] as! Chariot
        let rightMoves = board.validMoves(for: redRightChariot)
        
        // Should be able to move left along the top row
        XCTAssertTrue(rightMoves.contains(Position(row: 0, col: 7)), "Right chariot should move left")
        XCTAssertTrue(rightMoves.contains(Position(row: 0, col: 6)), "Right chariot should move left")
        
        // Should be able to move down along the right column
        XCTAssertTrue(rightMoves.contains(Position(row: 1, col: 8)), "Right chariot should move down")
        XCTAssertTrue(rightMoves.contains(Position(row: 2, col: 8)), "Right chariot should move down")
        
        // Test blue left chariot
        let blueLeftChariot = board.pieces[9][0] as! Chariot
        let blueMoves = board.validMoves(for: blueLeftChariot)
        
        // Should be able to move up along the left column
        XCTAssertTrue(blueMoves.contains(Position(row: 8, col: 0)), "Blue chariot should move up")
        XCTAssertTrue(blueMoves.contains(Position(row: 7, col: 0)), "Blue chariot should move up")
        
        // Should be able to move right along the bottom row
        XCTAssertTrue(blueMoves.contains(Position(row: 9, col: 1)), "Blue chariot should move right")
        XCTAssertTrue(blueMoves.contains(Position(row: 9, col: 2)), "Blue chariot should move right")
    }
    
    func testChariotEdgeCases() {
        // Test chariot at corner position
        let redChariot = board.pieces[0][0] as! Chariot
        
        // Move chariot to a corner
        board.pieces[0][0] = nil
        board.pieces[9][8] = redChariot
        redChariot.currentPosition = Position(row: 9, col: 8)
        
        let moves = board.validMoves(for: redChariot)
        
        // Should only be able to move up and left from corner
        XCTAssertTrue(moves.contains(Position(row: 8, col: 8)), "Corner chariot should move up")
        XCTAssertTrue(moves.contains(Position(row: 9, col: 7)), "Corner chariot should move left")
        
        // Should not be able to move down or right (out of bounds)
        XCTAssertFalse(moves.contains(Position(row: 10, col: 8)), "Corner chariot should not move down")
        XCTAssertFalse(moves.contains(Position(row: 9, col: 9)), "Corner chariot should not move right")
    }
    
    func testChariotAfterPawnMoves() {
        let redChariot = board.pieces[0][0] as! Chariot
        
        // Remove the red pawn that's blocking the chariot
        board.pieces[3][0] = nil
        
        // Move the blue pawn (enemy) down to open up space for the chariot
        let bluePawn = board.pieces[6][0] as! Pawn
        board.pieces[6][0] = nil
        board.pieces[4][0] = bluePawn
        bluePawn.currentPosition = Position(row: 4, col: 0)
        
        let moves = board.validMoves(for: redChariot)
        
        // Chariot should now be able to move down to row 3
        XCTAssertTrue(moves.contains(Position(row: 3, col: 0)), "Chariot should move down after pawn moves")
        
        // Should also be able to move to row 4 (capture the enemy pawn)
        XCTAssertTrue(moves.contains(Position(row: 4, col: 0)), "Chariot should be able to capture enemy pawn")
    }
} 