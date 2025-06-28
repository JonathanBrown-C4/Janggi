import XCTest
@testable import Janggi

final class ChariotTests: XCTestCase {
    func testChariotInitializationWithDefaultPosition() {
        let redLeftChariot = Chariot(isRed: true, isLeft: true)
        XCTAssertEqual(redLeftChariot.currentPosition, Position(row: 0, col: 0), "Red left chariot should start at (0,0)")
        XCTAssertTrue(redLeftChariot.isRed)
        XCTAssertEqual(redLeftChariot.imageName, "red_chariot")
        
        let redRightChariot = Chariot(isRed: true, isLeft: false)
        XCTAssertEqual(redRightChariot.currentPosition, Position(row: 0, col: 8), "Red right chariot should start at (0,8)")
        XCTAssertTrue(redRightChariot.isRed)
        XCTAssertEqual(redRightChariot.imageName, "red_chariot")
        
        let blueLeftChariot = Chariot(isRed: false, isLeft: true)
        XCTAssertEqual(blueLeftChariot.currentPosition, Position(row: 9, col: 0), "Blue left chariot should start at (9,0)")
        XCTAssertFalse(blueLeftChariot.isRed)
        XCTAssertEqual(blueLeftChariot.imageName, "blue_chariot")
        
        let blueRightChariot = Chariot(isRed: false, isLeft: false)
        XCTAssertEqual(blueRightChariot.currentPosition, Position(row: 9, col: 8), "Blue right chariot should start at (9,8)")
        XCTAssertFalse(blueRightChariot.isRed)
        XCTAssertEqual(blueRightChariot.imageName, "blue_chariot")
    }
    
    func testChariotInitializationWithCustomPosition() {
        let customPos = Position(row: 5, col: 5)
        let chariot = Chariot(isRed: true, position: customPos)
        XCTAssertEqual(chariot.currentPosition, customPos)
        XCTAssertTrue(chariot.isRed)
        XCTAssertEqual(chariot.imageName, "red_chariot")
    }
    
    func testChariotMovementRules() {
        let chariot = Chariot(isRed: true, isLeft: true)
        
        // Chariot should have exactly 4 movement rules
        XCTAssertEqual(chariot.movementRules.count, 4, "Chariot should have 4 movement rules")
        
        // Check that all four directions are present
        let directions = Set(chariot.movementRules.map { $0.direction })
        XCTAssertTrue(directions.contains(.up), "Chariot should be able to move up")
        XCTAssertTrue(directions.contains(.down), "Chariot should be able to move down")
        XCTAssertTrue(directions.contains(.left), "Chariot should be able to move left")
        XCTAssertTrue(directions.contains(.right), "Chariot should be able to move right")
        
        // Check that all rules have unlimited distance (maxDistance = 0)
        for rule in chariot.movementRules {
            XCTAssertEqual(rule.maxDistance, 0, "Chariot should have unlimited movement in each direction")
        }
    }
    
    func testChariotType() {
        let chariot = Chariot(isRed: true, isLeft: true)
        XCTAssertEqual(chariot.type, .chariot, "Chariot should have type .chariot")
    }
    
    func testChariotSize() {
        let chariot = Chariot(isRed: true, isLeft: true)
        XCTAssertEqual(chariot.size, .medium, "Chariot should have medium size")
    }
    
    func testChariotColor() {
        let redChariot = Chariot(isRed: true, isLeft: true)
        XCTAssertEqual(redChariot.color, .red, "Red chariot should have red color")
        
        let blueChariot = Chariot(isRed: false, isLeft: true)
        XCTAssertEqual(blueChariot.color, .blue, "Blue chariot should have blue color")
    }
} 