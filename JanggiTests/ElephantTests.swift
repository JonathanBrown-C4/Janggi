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
        
        // Elephant moves: 1 step orthogonal, then 2 steps diagonal from that position
        // From (4,4), the elephant can move:
        // - Up to (3,4), then diagonal 2 steps to (1,6), (1,2), (5,6), (5,2)
        // - Down to (5,4), then diagonal 2 steps to (3,6), (3,2), (7,6), (7,2)
        // - Left to (4,3), then diagonal 2 steps to (2,5), (2,1), (6,5), (6,1)
        // - Right to (4,5), then diagonal 2 steps to (2,7), (2,3), (6,7), (6,3)
        
        let expected = [
            // From up intermediate (3,4)
            Position(row: 1, col: 6), // Up-right from (3,4)
            Position(row: 1, col: 2), // Up-left from (3,4)
            Position(row: 5, col: 6), // Down-right from (3,4)
            Position(row: 5, col: 2), // Down-left from (3,4)
            
            // From down intermediate (5,4)
            Position(row: 3, col: 6), // Up-right from (5,4)
            Position(row: 3, col: 2), // Up-left from (5,4)
            Position(row: 7, col: 6), // Down-right from (5,4)
            Position(row: 7, col: 2), // Down-left from (5,4)
            
            // From left intermediate (4,3)
            Position(row: 2, col: 5), // Up-right from (4,3)
            Position(row: 2, col: 1), // Up-left from (4,3)
            Position(row: 6, col: 5), // Down-right from (4,3)
            Position(row: 6, col: 1), // Down-left from (4,3)
            
            // From right intermediate (4,5)
            Position(row: 2, col: 7), // Up-right from (4,5)
            Position(row: 2, col: 3), // Up-left from (4,5)
            Position(row: 6, col: 7), // Down-right from (4,5)
            Position(row: 6, col: 3)  // Down-left from (4,5)
        ]
        
        for pos in expected {
            XCTAssertTrue(moves.contains(pos), "Elephant should be able to move to \(pos)")
        }
        XCTAssertEqual(moves.count, 16, "Elephant should have 16 open moves")
    }
    
    func testBlockedByIntermediate() {
        let elephant = Elephant(isRed: true, position: Position(row: 4, col: 4))
        board.pieces[4][4] = elephant
        // Block the up intermediate position
        board.pieces[3][4] = Soldier(isRed: true, position: Position(row: 3, col: 4))
        let moves = board.validMoves(for: elephant)
        
        // All moves from the up intermediate position should be blocked
        let blockedMoves = [
            Position(row: 1, col: 6), // Up-right from (3,4)
            Position(row: 1, col: 2), // Up-left from (3,4)
            Position(row: 5, col: 6), // Down-right from (3,4)
            Position(row: 5, col: 2)  // Down-left from (3,4)
        ]
        
        for pos in blockedMoves {
            XCTAssertFalse(moves.contains(pos), "Elephant should not move to \(pos) if intermediate position is blocked")
        }
        
        // Should still have 12 moves from other intermediate positions
        XCTAssertEqual(moves.count, 12, "Elephant should have 12 moves when one intermediate position is blocked")
    }
    
    func testCaptureEnemy() {
        let elephant = Elephant(isRed: true, position: Position(row: 4, col: 4))
        board.pieces[4][4] = elephant
        // Place enemy at (1,6) - one of the possible elephant moves
        board.pieces[1][6] = Soldier(isRed: false, position: Position(row: 1, col: 6))
        let moves = board.validMoves(for: elephant)
        XCTAssertTrue(moves.contains(Position(row: 1, col: 6)), "Elephant should be able to capture enemy at (1,6)")
    }
    
    func testCannotCaptureFriendly() {
        let elephant = Elephant(isRed: true, position: Position(row: 4, col: 4))
        board.pieces[4][4] = elephant
        // Place friendly at (1,6) - one of the possible elephant moves
        board.pieces[1][6] = Soldier(isRed: true, position: Position(row: 1, col: 6))
        let moves = board.validMoves(for: elephant)
        XCTAssertFalse(moves.contains(Position(row: 1, col: 6)), "Elephant should not be able to capture friendly at (1,6)")
    }
    
    func testCannotMoveWhenAllIntermediatesBlocked() {
        let elephant = Elephant(isRed: true, position: Position(row: 4, col: 4))
        board.pieces[4][4] = elephant
        // Block all intermediate positions
        board.pieces[3][4] = Soldier(isRed: true, position: Position(row: 3, col: 4)) // Up
        board.pieces[5][4] = Soldier(isRed: true, position: Position(row: 5, col: 4)) // Down
        board.pieces[4][3] = Soldier(isRed: true, position: Position(row: 4, col: 3)) // Left
        board.pieces[4][5] = Soldier(isRed: true, position: Position(row: 4, col: 5)) // Right
        let moves = board.validMoves(for: elephant)
        XCTAssertEqual(moves.count, 0, "Elephant should have no moves when all intermediate positions are blocked")
    }
    
    func testDebugElephantMovement() {
        let elephant = Elephant(isRed: true, position: Position(row: 4, col: 4))
        board.pieces[4][4] = elephant
        
        // Print movement rules
        print("Elephant movement rules: \(elephant.movementRules)")
        for (index, rule) in elephant.movementRules.enumerated() {
            print("Rule \(index): direction=\(rule.direction), maxDistance=\(rule.maxDistance), blockingRules=\(rule.blockingRules)")
        }
        
        // Get actual moves
        let moves = board.validMoves(for: elephant)
        print("Actual Elephant moves: \(moves)")
        
        // Expected moves (1 step orthogonal, then 2 steps diagonal)
        let expectedMoves = [
            // From up intermediate (3,4)
            Position(row: 1, col: 6), Position(row: 1, col: 2), Position(row: 5, col: 6), Position(row: 5, col: 2),
            // From down intermediate (5,4)
            Position(row: 3, col: 6), Position(row: 3, col: 2), Position(row: 7, col: 6), Position(row: 7, col: 2),
            // From left intermediate (4,3)
            Position(row: 2, col: 5), Position(row: 2, col: 1), Position(row: 6, col: 5), Position(row: 6, col: 1),
            // From right intermediate (4,5)
            Position(row: 2, col: 7), Position(row: 2, col: 3), Position(row: 6, col: 7), Position(row: 6, col: 3)
        ]
        print("Expected Elephant moves: \(expectedMoves)")
        
        // Check if moves contain any direct orthogonal moves (which would be wrong)
        let directOrthogonalMoves = moves.filter { move in
            let rowDiff = abs(move.row - 4)
            let colDiff = abs(move.col - 4)
            return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1)
        }
        
        if !directOrthogonalMoves.isEmpty {
            print("ERROR: Elephant has direct orthogonal moves: \(directOrthogonalMoves)")
        }
        
        // Check if moves contain correct pattern (1 orthogonal + 2 diagonal)
        for expected in expectedMoves {
            XCTAssertTrue(moves.contains(expected), "Elephant should be able to move to \(expected)")
        }
        
        XCTAssertEqual(moves.count, 16, "Elephant should have exactly 16 moves (4 orthogonal × 4 diagonal)")
    }
    
    func testDebugActualMoves() {
        let elephant = Elephant(isRed: true, position: Position(row: 4, col: 4))
        board.pieces[4][4] = elephant
        let moves = board.validMoves(for: elephant)
        
        var debugOutput = "=== ELEPHANT DEBUG ===\n"
        debugOutput += "Elephant at position: (4,4)\n"
        debugOutput += "Total moves generated: \(moves.count)\n"
        debugOutput += "All moves:\n"
        
        for (index, move) in moves.enumerated() {
            let rowDiff = move.row - 4
            let colDiff = move.col - 4
            let distance = abs(rowDiff) + abs(colDiff)
            let isOrthogonal = (abs(rowDiff) == 1 && abs(colDiff) == 0) || (abs(rowDiff) == 0 && abs(colDiff) == 1)
            let isDiagonal = abs(rowDiff) == abs(colDiff) && abs(rowDiff) > 0
            let moveType = isOrthogonal ? "ORTHOGONAL" : (isDiagonal ? "DIAGONAL" : "OTHER")
            debugOutput += "  \(index + 1). (\(move.row),\(move.col)) - Distance: \(distance), Type: \(moveType)\n"
        }
        
        // Check for intermediate positions (1 step away)
        let intermediateMoves = moves.filter { move in
            let rowDiff = abs(move.row - 4)
            let colDiff = abs(move.col - 4)
            return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1)
        }
        
        if !intermediateMoves.isEmpty {
            debugOutput += "ERROR: Found intermediate moves: \(intermediateMoves)\n"
            XCTFail("Elephant should not have intermediate moves")
        } else {
            debugOutput += "✓ No intermediate moves found\n"
        }
        
        // Check for final diagonal positions (2 steps away)
        let finalDiagonalMoves = moves.filter { move in
            let rowDiff = abs(move.row - 4)
            let colDiff = abs(move.col - 4)
            return rowDiff == 2 && colDiff == 2
        }
        
        debugOutput += "Final diagonal moves: \(finalDiagonalMoves.count)\n"
        debugOutput += "=== END DEBUG ===\n"
        
        // Write to a file in the Documents directory
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let debugFileURL = documentsPath.appendingPathComponent("elephant_debug.txt")
        
        do {
            try debugOutput.write(to: debugFileURL, atomically: true, encoding: .utf8)
            print("Debug output written to: \(debugFileURL.path)")
        } catch {
            print("Failed to write debug output: \(error)")
        }
    }
} 