//final class CannonTests: BaseJanggiTests {
//    func testCannonMovement() {
//        // Clear the board first
//        for row in 0..<10 {
//            for col in 0..<9 {
//                board.pieces[row][col] = nil
//            }
//        }
//        
//        // Place cannon at initial position
//        let initialPos = Position(row: 2, col: 1)
//        let cannon = Cannon(isRed: true, position: initialPos)
//        board.pieces[initialPos.row][initialPos.col] = cannon
//        
//        XCTAssertNotNil(board.pieces[initialPos.row][initialPos.col], "Cannon should exist at initial position")
//        XCTAssertTrue(board.pieces[initialPos.row][initialPos.col] is Cannon, "Piece at initial position should be a Cannon")
//        
//        print("Initial Cannon position: \(cannon.currentPosition)")
//        print("Cannon is red: \(cannon.isRed)")
//        
//        // Test that cannon cannot move without a platform
//        let basicMoves = [
//            Position(row: 2, col: 0), // left
//            Position(row: 2, col: 2), // right
//            Position(row: 1, col: 1), // up
//            Position(row: 3, col: 1)  // down
//        ]
//        
//        let actualMoves = cannon.validMoves(board: board)
//        print("\nBasic movement test (no platform):")
//        print("Actual valid moves: \(actualMoves)")
//        
//        // Debug: Print each move and why it's valid/invalid
//        for move in basicMoves {
//            let isWithinBounds = cannon.isWithinBounds(move)
//            let isOccupiedBySameColor = cannon.isOccupiedBySameColor(move, board: board)
//            let pieceAtPosition = board.pieceAt(move)
//            print("Move \(move):")
//            print("  - Within bounds: \(isWithinBounds)")
//            print("  - Occupied by same color: \(isOccupiedBySameColor)")
//            print("  - Piece at position: \(pieceAtPosition?.imageName ?? "none")")
//            print("  - Is valid: \(actualMoves.contains(move))")
//        }
//        
//        for move in basicMoves {
//            XCTAssertFalse(actualMoves.contains(move), "Cannon should not be able to move to \(move) without a platform")
//        }
//        
//        // Test movement with platform in row
//        let platformPos = Position(row: 2, col: 3)
//        board.pieces[2][3] = Pawn(isRed: true, position: platformPos)
//        let movesWithPlatform = cannon.validMoves(board: board)
//        print("\nAfter adding platform at \(platformPos):")
//        print("Valid moves with platform: \(movesWithPlatform)")
//        
//        // Test that moves on same side as cannon are invalid
//        let invalidMovesSameSide = [
//            Position(row: 2, col: 0),
//            Position(row: 2, col: 2)
//        ]
//        
//        for move in invalidMovesSameSide {
//            XCTAssertFalse(movesWithPlatform.contains(move), "Cannon should not be able to move to \(move) on same side as platform")
//        }
//        
//        // Test that moves on opposite side of platform are valid
//        let validMovesOppositeSide = [
//            Position(row: 2, col: 4),
//            Position(row: 2, col: 5)
//        ]
//        
//        for move in validMovesOppositeSide {
//            XCTAssertTrue(movesWithPlatform.contains(move), "Cannon should be able to move to \(move) on opposite side of platform")
//        }
//        
//        // Test capture with platform
//        let targetPos = Position(row: 2, col: 4)
//        board.pieces[2][4] = Pawn(isRed: false, position: targetPos)
//        let movesWithCapture = cannon.validMoves(board: board)
//        print("\nAfter adding enemy piece at \(targetPos):")
//        print("Valid moves with capture: \(movesWithCapture)")
//        
//        XCTAssertTrue(movesWithCapture.contains(targetPos), "Cannon should be able to capture enemy piece")
//        
//        // Test invalid capture (no platform)
//        board.pieces[2][3] = nil // Remove platform
//        let movesWithoutPlatform = cannon.validMoves(board: board)
//        print("\nAfter removing platform:")
//        print("Valid moves without platform: \(movesWithoutPlatform)")
//        
//        XCTAssertFalse(movesWithoutPlatform.contains(targetPos), "Cannon should not be able to capture without platform")
//        
//        // Test movement with platform in column
//        let columnPlatformPos = Position(row: 4, col: 1)
//        board.pieces[4][1] = Pawn(isRed: true, position: columnPlatformPos)
//        let movesWithColumnPlatform = cannon.validMoves(board: board)
//        print("\nAfter adding platform at \(columnPlatformPos):")
//        print("Valid moves with column platform: \(movesWithColumnPlatform)")
//        
//        // Test that moves on same side as cannon are invalid
//        let invalidMovesSameSideColumn = [
//            Position(row: 0, col: 1),
//            Position(row: 1, col: 1),
//            Position(row: 3, col: 1)
//        ]
//        
//        for move in invalidMovesSameSideColumn {
//            XCTAssertFalse(movesWithColumnPlatform.contains(move), "Cannon should not be able to move to \(move) on same side as platform")
//        }
//        
//        // Test that moves on opposite side of platform are valid
//        let validMovesOppositeSideColumn = [
//            Position(row: 5, col: 1),
//            Position(row: 6, col: 1)
//        ]
//        
//        for move in validMovesOppositeSideColumn {
//            XCTAssertTrue(movesWithColumnPlatform.contains(move), "Cannon should be able to move to \(move) on opposite side of platform")
//        }
//        
//        // Test capture with column platform
//        let columnTargetPos = Position(row: 5, col: 1)
//        board.pieces[5][1] = Pawn(isRed: false, position: columnTargetPos)
//        let movesWithColumnCapture = cannon.validMoves(board: board)
//        print("\nAfter adding enemy piece at \(columnTargetPos):")
//        print("Valid moves with column capture: \(movesWithColumnCapture)")
//        
//        XCTAssertTrue(movesWithColumnCapture.contains(columnTargetPos), "Cannon should be able to capture enemy piece over column platform")
//    }
//} 