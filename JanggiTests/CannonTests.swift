import XCTest
@testable import Janggi

final class CannonTests: XCTestCase {
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
    
    func testCannotMoveWithoutPlatform() {
        let cannon = Cannon(isRed: true, position: Position(row: 4, col: 4))
        board.pieces[4][4] = cannon
        let moves = board.validMoves(for: cannon)
        // Cannon should not be able to move without a platform
        XCTAssertEqual(moves.count, 0, "Cannon should have no moves without platform")
    }
    
    func testMovementWithPlatform() {
        let cannon = Cannon(isRed: true, position: Position(row: 4, col: 2))
        board.pieces[4][2] = cannon
        // Add platform at (4,4)
        board.pieces[4][4] = Soldier(isRed: true, position: Position(row: 4, col: 4))
        let moves = board.validMoves(for: cannon)
        // Should be able to move to positions beyond the platform
        XCTAssertTrue(moves.contains(Position(row: 4, col: 5)), "Cannon should move beyond platform")
        XCTAssertTrue(moves.contains(Position(row: 4, col: 6)), "Cannon should move beyond platform")
        // Should not be able to move to positions before the platform
        XCTAssertFalse(moves.contains(Position(row: 4, col: 3)), "Cannon should not move before platform")
    }
    
    func testCaptureWithPlatform() {
        let cannon = Cannon(isRed: true, position: Position(row: 4, col: 2))
        board.pieces[4][2] = cannon
        // Add platform at (4,4)
        board.pieces[4][4] = Soldier(isRed: true, position: Position(row: 4, col: 4))
        // Add enemy at (4,5)
        board.pieces[4][5] = Soldier(isRed: false, position: Position(row: 4, col: 5))
        let moves = board.validMoves(for: cannon)
        XCTAssertTrue(moves.contains(Position(row: 4, col: 5)), "Cannon should capture enemy over platform")
    }
    
    func testCannotCaptureFriendlyOverPlatform() {
        let cannon = Cannon(isRed: true, position: Position(row: 4, col: 2))
        board.pieces[4][2] = cannon
        // Add platform at (4,4)
        board.pieces[4][4] = Soldier(isRed: true, position: Position(row: 4, col: 4))
        // Add friendly at (4,5)
        board.pieces[4][5] = Soldier(isRed: true, position: Position(row: 4, col: 5))
        let moves = board.validMoves(for: cannon)
        XCTAssertFalse(moves.contains(Position(row: 4, col: 5)), "Cannon should not capture friendly over platform")
    }
    
    func testVerticalMovementWithPlatform() {
        let cannon = Cannon(isRed: true, position: Position(row: 2, col: 4))
        board.pieces[2][4] = cannon
        // Add platform at (4,4)
        board.pieces[4][4] = Soldier(isRed: true, position: Position(row: 4, col: 4))
        let moves = board.validMoves(for: cannon)
        // Should be able to move to positions beyond the platform
        XCTAssertTrue(moves.contains(Position(row: 5, col: 4)), "Cannon should move vertically beyond platform")
        XCTAssertTrue(moves.contains(Position(row: 6, col: 4)), "Cannon should move vertically beyond platform")
        // Should not be able to move to positions before the platform
        XCTAssertFalse(moves.contains(Position(row: 3, col: 4)), "Cannon should not move vertically before platform")
    }
    
    func testMultiplePlatforms() {
        let cannon = Cannon(isRed: true, position: Position(row: 4, col: 2))
        board.pieces[4][2] = cannon
        // Add first platform at (4,4)
        board.pieces[4][4] = Soldier(isRed: true, position: Position(row: 4, col: 4))
        // Add second platform at (4,6)
        board.pieces[4][6] = Soldier(isRed: false, position: Position(row: 4, col: 6))
        let moves = board.validMoves(for: cannon)
        // Should be able to capture the second platform (enemy)
        XCTAssertTrue(moves.contains(Position(row: 4, col: 6)), "Cannon should capture second platform if enemy")
        // Should not be able to move beyond second platform
        XCTAssertFalse(moves.contains(Position(row: 4, col: 7)), "Cannon should not move beyond second platform")
    }
    
    func testBlueCannonMovement() {
        let cannon = Cannon(isRed: false, position: Position(row: 6, col: 4))
        board.pieces[6][4] = cannon
        // Add platform at (4,4)
        board.pieces[4][4] = Soldier(isRed: true, position: Position(row: 4, col: 4))
        let moves = board.validMoves(for: cannon)
        // Blue cannon should be able to move beyond platform
        XCTAssertTrue(moves.contains(Position(row: 3, col: 4)), "Blue cannon should move beyond platform")
        XCTAssertTrue(moves.contains(Position(row: 2, col: 4)), "Blue cannon should move beyond platform")
    }
} 