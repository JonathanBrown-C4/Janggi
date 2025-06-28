//import XCTest
//@testable import Janggi
//
//final class GeneralTests: BaseJanggiTests {
//    func testGeneralMovement() {
//        // Test initial position
//        let initialPos = Position(row: 0, col: 4)
//        XCTAssertNotNil(board.pieces[initialPos.row][initialPos.col], "General should exist at initial position")
//        XCTAssertTrue(board.pieces[initialPos.row][initialPos.col] is General, "Piece at initial position should be a General")
//        
//        guard let general = board.pieces[initialPos.row][initialPos.col] as? General else {
//            XCTFail("Failed to cast piece to General")
//            return
//        }
//        
//        print("Initial General position: \(general.currentPosition)")
//        print("General is red: \(general.isRed)")
//        
//        // Test valid moves within palace
//        let validMoves = [
//            Position(row: 1, col: 4), // down
//            Position(row: 1, col: 3), // diagonal down-left
//            Position(row: 1, col: 5)  // diagonal down-right
//        ]
//        
//        let actualMoves = general.validMoves(board: board)
//        print("Actual valid moves: \(actualMoves)")
//        
//        // Debug: Print each move and why it's valid/invalid
//        for move in validMoves {
//            let isWithinBounds = general.isWithinBounds(move)
//            let isInPalace = (0...2).contains(move.row)
//            let isInCenterCols = (3...5).contains(move.col)
//            let isOccupiedBySameColor = general.isOccupiedBySameColor(move, board: board)
//            let pieceAtPosition = board.pieceAt(move)
//            print("Move \(move):")
//            print("  - Within bounds: \(isWithinBounds)")
//            print("  - In palace: \(isInPalace)")
//            print("  - In center cols: \(isInCenterCols)")
//            print("  - Occupied by same color: \(isOccupiedBySameColor)")
//            print("  - Piece at position: \(pieceAtPosition?.imageName ?? "none")")
//            print("  - Is valid: \(actualMoves.contains(move))")
//        }
//        
//        // Verify that all expected moves are in the actual moves
//        for move in validMoves {
//            XCTAssertTrue(actualMoves.contains(move), "General should be able to move to \(move)")
//        }
//        
//        // Test invalid moves outside palace
//        let invalidMoves = [
//            Position(row: 0, col: 2), // too far left
//            Position(row: 0, col: 6), // too far right
//            Position(row: 2, col: 4), // too far down
//            Position(row: 2, col: 3), // too far down-left
//            Position(row: 2, col: 5)  // too far down-right
//        ]
//        
//        for move in invalidMoves {
//            XCTAssertFalse(actualMoves.contains(move), "General should not be able to move to \(move)")
//        }
//        
//        // Move the General to a position where it has more valid moves
//        board.pieces[1][4] = general
//        board.pieces[0][4] = nil
//        general.currentPosition = Position(row: 1, col: 4)
//        
//        print("\nAfter moving General to center position:")
//        print("New General position: \(general.currentPosition)")
//        
//        let newMoves = general.validMoves(board: board)
//        print("New valid moves after repositioning: \(newMoves)")
//        
//        // Verify that the General can move to all adjacent positions in the palace
//        let expectedNewMoves = [
//            Position(row: 1, col: 3), // left
//            Position(row: 1, col: 5), // right
//            Position(row: 0, col: 4), // up
//            Position(row: 2, col: 4), // down
//            Position(row: 2, col: 3), // down-left
//            Position(row: 2, col: 5)  // down-right
//        ]
//        
//        // Debug: Print each move and why it's valid/invalid after repositioning
//        for move in expectedNewMoves {
//            let isWithinBounds = general.isWithinBounds(move)
//            let isInPalace = (0...2).contains(move.row)
//            let isInCenterCols = (3...5).contains(move.col)
//            let isOccupiedBySameColor = general.isOccupiedBySameColor(move, board: board)
//            let pieceAtPosition = board.pieceAt(move)
//            print("Move \(move):")
//            print("  - Within bounds: \(isWithinBounds)")
//            print("  - In palace: \(isInPalace)")
//            print("  - In center cols: \(isInCenterCols)")
//            print("  - Occupied by same color: \(isOccupiedBySameColor)")
//            print("  - Piece at position: \(pieceAtPosition?.imageName ?? "none")")
//            print("  - Is valid: \(newMoves.contains(move))")
//        }
//        
//        for move in expectedNewMoves {
//            XCTAssertTrue(newMoves.contains(move), "General should be able to move to \(move) from center position")
//        }
//    }
//} 