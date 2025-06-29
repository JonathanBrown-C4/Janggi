import XCTest
@testable import Janggi

final class PawnTests: XCTestCase {
    func testPawnInitializationWithDefaultPosition() {
        let redPawn = Pawn(isRed: true, column: 0)
        XCTAssertEqual(redPawn.currentPosition, Position(row: 3, col: 0), "Red pawn should start at (3,0)")
        XCTAssertTrue(redPawn.isRed)
        XCTAssertEqual(redPawn.imageName, "red_pawn")
        
        let bluePawn = Pawn(isRed: false, column: 0)
        XCTAssertEqual(bluePawn.currentPosition, Position(row: 6, col: 0), "Blue pawn should start at (6,0)")
        XCTAssertFalse(bluePawn.isRed)
        XCTAssertEqual(bluePawn.imageName, "blue_pawn")
    }
    
    func testPawnInitializationWithCustomPosition() {
        let customPos = Position(row: 5, col: 5)
        let pawn = Pawn(isRed: true, position: customPos)
        XCTAssertEqual(pawn.currentPosition, customPos)
        XCTAssertTrue(pawn.isRed)
        XCTAssertEqual(pawn.imageName, "red_pawn")
    }
    
    func testPawnMovementRulesBeforeCrossingRiver() {
        // Red pawn at starting position (row 3) - hasn't crossed river yet
        let redPawn = Pawn(isRed: true, column: 0)
        XCTAssertEqual(redPawn.currentPosition, Position(row: 3, col: 0))
        
        let rules = redPawn.movementRules
        XCTAssertEqual(rules.count, 1, "Red pawn should have 1 movement rule before crossing river")
        XCTAssertEqual(rules[0].direction, .down, "Red pawn should move down before crossing river")
        XCTAssertEqual(rules[0].maxDistance, 1, "Red pawn should move 1 square")
        
        // Blue pawn at starting position (row 6) - hasn't crossed river yet
        let bluePawn = Pawn(isRed: false, column: 0)
        XCTAssertEqual(bluePawn.currentPosition, Position(row: 6, col: 0))
        
        let blueRules = bluePawn.movementRules
        XCTAssertEqual(blueRules.count, 1, "Blue pawn should have 1 movement rule before crossing river")
        XCTAssertEqual(blueRules[0].direction, .up, "Blue pawn should move up before crossing river")
        XCTAssertEqual(blueRules[0].maxDistance, 1, "Blue pawn should move 1 square")
    }
    
    func testPawnMovementRulesAfterCrossingRiver() {
        // Red pawn after crossing river (row 5)
        let redPawn = Pawn(isRed: true, position: Position(row: 5, col: 0))
        XCTAssertEqual(redPawn.currentPosition, Position(row: 5, col: 0))
        
        let rules = redPawn.movementRules
        XCTAssertEqual(rules.count, 3, "Red pawn should have 3 movement rules after crossing river")
        
        let directions = Set(rules.map { $0.direction })
        XCTAssertTrue(directions.contains(.down), "Red pawn should be able to move down after crossing river")
        XCTAssertTrue(directions.contains(.left), "Red pawn should be able to move left after crossing river")
        XCTAssertTrue(directions.contains(.right), "Red pawn should be able to move right after crossing river")
        
        for rule in rules {
            XCTAssertEqual(rule.maxDistance, 1, "Red pawn should move 1 square in each direction")
        }
        
        // Blue pawn after crossing river (row 4)
        let bluePawn = Pawn(isRed: false, position: Position(row: 4, col: 0))
        XCTAssertEqual(bluePawn.currentPosition, Position(row: 4, col: 0))
        
        let blueRules = bluePawn.movementRules
        XCTAssertEqual(blueRules.count, 3, "Blue pawn should have 3 movement rules after crossing river")
        
        let blueDirections = Set(blueRules.map { $0.direction })
        XCTAssertTrue(blueDirections.contains(.up), "Blue pawn should be able to move up after crossing river")
        XCTAssertTrue(blueDirections.contains(.left), "Blue pawn should be able to move left after crossing river")
        XCTAssertTrue(blueDirections.contains(.right), "Blue pawn should be able to move right after crossing river")
        
        for rule in blueRules {
            XCTAssertEqual(rule.maxDistance, 1, "Blue pawn should move 1 square in each direction")
        }
    }
    
    func testPawnType() {
        let pawn = Pawn(isRed: true, column: 0)
        XCTAssertEqual(pawn.type, .pawn, "Pawn should have type .pawn")
    }
    
    func testPawnSize() {
        let pawn = Pawn(isRed: true, column: 0)
        XCTAssertEqual(pawn.size, .small, "Pawn should have small size")
    }
    
    func testPawnColor() {
        let redPawn = Pawn(isRed: true, column: 0)
        XCTAssertEqual(redPawn.color, .red, "Red pawn should have red color")
        
        let bluePawn = Pawn(isRed: false, column: 0)
        XCTAssertEqual(bluePawn.color, .blue, "Blue pawn should have blue color")
    }
}
