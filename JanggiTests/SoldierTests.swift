import XCTest
@testable import Janggi

final class SoldierTests: XCTestCase {
    func testSoldierInitializationWithDefaultPosition() {
        let redSoldier = Soldier(isRed: true, column: 0)
        XCTAssertEqual(redSoldier.currentPosition, Position(row: 3, col: 0), "Red soldier should start at (3,0)")
        XCTAssertTrue(redSoldier.isRed)
        XCTAssertEqual(redSoldier.imageName, "red_soldier")
        
        let blueSoldier = Soldier(isRed: false, column: 0)
        XCTAssertEqual(blueSoldier.currentPosition, Position(row: 6, col: 0), "Blue soldier should start at (6,0)")
        XCTAssertFalse(blueSoldier.isRed)
        XCTAssertEqual(blueSoldier.imageName, "blue_soldier")
    }
    
    func testSoldierInitializationWithCustomPosition() {
        let customPos = Position(row: 5, col: 5)
        let soldier = Soldier(isRed: true, position: customPos)
        XCTAssertEqual(soldier.currentPosition, customPos)
        XCTAssertTrue(soldier.isRed)
        XCTAssertEqual(soldier.imageName, "red_soldier")
    }
    
    func testSoldierMovementRulesBeforeCrossingRiver() {
        // Red soldier at starting position (row 3) - hasn't crossed river yet
        let redSoldier = Soldier(isRed: true, column: 0)
        XCTAssertEqual(redSoldier.currentPosition, Position(row: 3, col: 0))
        
        let rules = redSoldier.movementRules
        XCTAssertEqual(rules.count, 1, "Red soldier should have 1 movement rule before crossing river")
        XCTAssertEqual(rules[0].direction, .orthogonal, "Red soldier should have orthogonal movement rule")
        XCTAssertEqual(rules[0].maxDistance, 1, "Red soldier should move 1 square")
        
        // Validate actual moves on the board
        let board = Board()
        let redPos = redSoldier.currentPosition
        board.pieces[redPos.row][redPos.col] = redSoldier
        let moves = board.validMoves(for: redSoldier)
        XCTAssertTrue(moves.contains(Position(row: 4, col: 0)), "Red soldier should be able to move forward before crossing river")
        XCTAssertTrue(moves.contains(Position(row: 3, col: 1)), "Red soldier should be able to move right before crossing river")
        XCTAssertEqual(moves.count, 2, "Red soldier should be able to move forward and right before crossing river (left is out of bounds)")
        
        // Blue soldier at starting position (row 6) - hasn't crossed river yet
        let blueSoldier = Soldier(isRed: false, column: 0)
        XCTAssertEqual(blueSoldier.currentPosition, Position(row: 6, col: 0))
        
        let blueRules = blueSoldier.movementRules
        XCTAssertEqual(blueRules.count, 1, "Blue soldier should have 1 movement rule before crossing river")
        XCTAssertEqual(blueRules[0].direction, .orthogonal, "Blue soldier should have orthogonal movement rule")
        XCTAssertEqual(blueRules[0].maxDistance, 1, "Blue soldier should move 1 square")
        
        // Validate actual moves on the board
        let bluePos = blueSoldier.currentPosition
        board.pieces[bluePos.row][bluePos.col] = blueSoldier
        let blueMoves = board.validMoves(for: blueSoldier)
        XCTAssertTrue(blueMoves.contains(Position(row: 5, col: 0)), "Blue soldier should be able to move forward before crossing river")
        XCTAssertTrue(blueMoves.contains(Position(row: 6, col: 1)), "Blue soldier should be able to move right before crossing river")
        XCTAssertEqual(blueMoves.count, 2, "Blue soldier should be able to move forward and right before crossing river (left is out of bounds)")
    }
    
    func testSoldierMovementRulesAfterCrossingRiver() {
        // Red soldier after crossing river (row 5)
        let redSoldier = Soldier(isRed: true, position: Position(row: 5, col: 4))
        XCTAssertEqual(redSoldier.currentPosition, Position(row: 5, col: 4))
        
        let rules = redSoldier.movementRules
        XCTAssertEqual(rules.count, 1, "Red soldier should have 1 movement rule after crossing river")
        XCTAssertEqual(rules[0].direction, .orthogonal, "Red soldier should have orthogonal movement rule")
        XCTAssertEqual(rules[0].maxDistance, 1, "Red soldier should move 1 square")
        
        // Validate actual moves on the board
        let board = Board()
        let redPos = redSoldier.currentPosition
        board.pieces[redPos.row][redPos.col] = redSoldier
        let moves = board.validMoves(for: redSoldier)
        XCTAssertTrue(moves.contains(Position(row: 6, col: 4)), "Red soldier should be able to move forward after crossing river")
        XCTAssertTrue(moves.contains(Position(row: 5, col: 3)), "Red soldier should be able to move left after crossing river")
        XCTAssertTrue(moves.contains(Position(row: 5, col: 5)), "Red soldier should be able to move right after crossing river")
        XCTAssertEqual(moves.count, 3, "Red soldier should be able to move forward and sideways after crossing river")
        
        // Blue soldier after crossing river (row 4)
        let blueSoldier = Soldier(isRed: false, position: Position(row: 4, col: 4))
        XCTAssertEqual(blueSoldier.currentPosition, Position(row: 4, col: 4))
        
        let blueRules = blueSoldier.movementRules
        XCTAssertEqual(blueRules.count, 1, "Blue soldier should have 1 movement rule after crossing river")
        XCTAssertEqual(blueRules[0].direction, .orthogonal, "Blue soldier should have orthogonal movement rule")
        XCTAssertEqual(blueRules[0].maxDistance, 1, "Blue soldier should move 1 square")
        
        // Validate actual moves on the board
        let bluePos = blueSoldier.currentPosition
        board.pieces[bluePos.row][bluePos.col] = blueSoldier
        let blueMoves = board.validMoves(for: blueSoldier)
        XCTAssertTrue(blueMoves.contains(Position(row: 3, col: 4)), "Blue soldier should be able to move forward after crossing river")
        XCTAssertTrue(blueMoves.contains(Position(row: 4, col: 3)), "Blue soldier should be able to move left after crossing river")
        XCTAssertTrue(blueMoves.contains(Position(row: 4, col: 5)), "Blue soldier should be able to move right after crossing river")
        XCTAssertEqual(blueMoves.count, 3, "Blue soldier should be able to move forward and sideways after crossing river")
    }
    
    func testSoldierType() {
        let soldier = Soldier(isRed: true, column: 0)
        XCTAssertEqual(soldier.type, .soldier, "Soldier should have type .soldier")
    }
    
    func testSoldierSize() {
        let soldier = Soldier(isRed: true, column: 0)
        XCTAssertEqual(soldier.size, .small, "Soldier should have small size")
    }
    
    func testSoldierColor() {
        let redSoldier = Soldier(isRed: true, column: 0)
        XCTAssertEqual(redSoldier.color, .red, "Red soldier should have red color")
        
        let blueSoldier = Soldier(isRed: false, column: 0)
        XCTAssertEqual(blueSoldier.color, .blue, "Blue soldier should have blue color")
    }
}
