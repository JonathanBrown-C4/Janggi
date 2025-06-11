import XCTest
@testable import Janggi

final class BoardTests: XCTestCase {
    var board: Board!
    
    override func setUp() {
        super.setUp()
        board = Board()
        board.setupBoard()
    }
    
    override func tearDown() {
        board = nil
        super.tearDown()
    }
    
    func testBoardInitialization() {
        // Test board dimensions
        XCTAssertEqual(board.pieces.count, 10, "Board should have 10 rows")
        XCTAssertEqual(board.pieces[0].count, 9, "Board should have 9 columns")
        
        // Test initial piece placement
        XCTAssertNotNil(board.pieces[0][0], "Chariot should be at (0,0)")
        XCTAssertNotNil(board.pieces[0][1], "Horse should be at (0,1)")
        XCTAssertNotNil(board.pieces[0][2], "Elephant should be at (0,2)")
        XCTAssertNotNil(board.pieces[0][3], "Guard should be at (0,3)")
        XCTAssertNotNil(board.pieces[0][4], "General should be at (0,4)")
        XCTAssertNotNil(board.pieces[0][5], "Guard should be at (0,5)")
        XCTAssertNotNil(board.pieces[0][6], "Elephant should be at (0,6)")
        XCTAssertNotNil(board.pieces[0][7], "Horse should be at (0,7)")
        XCTAssertNotNil(board.pieces[0][8], "Chariot should be at (0,8)")
        
        // Test initial game state
        XCTAssertTrue(board.isRedTurn, "Red should start first")
        XCTAssertEqual(board.gameState, .playing, "Game should start in playing state")
        XCTAssertTrue(board.capturedRedPieces.isEmpty, "No red pieces should be captured initially")
        XCTAssertTrue(board.capturedBluePieces.isEmpty, "No blue pieces should be captured initially")
        XCTAssertNil(board.selectedPiece, "No piece should be selected initially")
        XCTAssertTrue(board.validMoves.isEmpty, "No valid moves should be available initially")
    }
    
    func testPieceAt() {
        // Test valid position
        let position = Position(row: 0, col: 4)
        XCTAssertNotNil(board.pieceAt(position), "Should return piece at valid position")
        
        // Test empty position
        let emptyPosition = Position(row: 4, col: 4)
        XCTAssertNil(board.pieceAt(emptyPosition), "Should return nil for empty position")
        
        // Test out of bounds positions
        let negativeRow = Position(row: -1, col: 4)
        XCTAssertNil(board.pieceAt(negativeRow), "Should return nil for negative row")
        
        let negativeCol = Position(row: 4, col: -1)
        XCTAssertNil(board.pieceAt(negativeCol), "Should return nil for negative column")
        
        let tooLargeRow = Position(row: 10, col: 4)
        XCTAssertNil(board.pieceAt(tooLargeRow), "Should return nil for row >= 10")
        
        let tooLargeCol = Position(row: 4, col: 9)
        XCTAssertNil(board.pieceAt(tooLargeCol), "Should return nil for column >= 9")
    }
    
    func testPieceMovement() {
        // Test valid move
        let fromPos = Position(row: 3, col: 0)
        let toPos = Position(row: 4, col: 0)
        let originalPiece = board.pieces[fromPos.row][fromPos.col]
        XCTAssertTrue(board.isRedTurn, "Should start with red's turn")
        board.movePiece(from: fromPos, to: toPos)
        XCTAssertNil(board.pieces[fromPos.row][fromPos.col], "Original position should be empty")
        XCTAssertTrue(board.pieces[toPos.row][toPos.col] === originalPiece, "Piece should be at new position")
        XCTAssertFalse(board.isRedTurn, "Turn should switch to blue after valid move")
        
        // Test invalid move (wrong turn)
        // Try to move a red piece when it's blue's turn
        let invalidFromPos = Position(row: 3, col: 2) // Red pawn
        let invalidToPos = Position(row: 4, col: 2)
        let pieceBeforeMove = board.pieces[invalidFromPos.row][invalidFromPos.col]
        let turnBeforeMove = board.isRedTurn
        board.movePiece(from: invalidFromPos, to: invalidToPos)
        XCTAssertTrue(board.pieces[invalidFromPos.row][invalidFromPos.col] === pieceBeforeMove, "Piece should not move on opponent's turn")
        XCTAssertEqual(board.isRedTurn, turnBeforeMove, "Turn should not change after invalid move")
        
        // Test invalid moves (out of bounds)
        let validPiece = board.pieces[toPos.row][toPos.col]
        
        // Test negative row
        let negativeRowPos = Position(row: -1, col: 0)
        let turnBeforeNegativeRow = board.isRedTurn
        board.movePiece(from: toPos, to: negativeRowPos)
        XCTAssertTrue(board.pieces[toPos.row][toPos.col] === validPiece, "Piece should not move to negative row")
        XCTAssertEqual(board.isRedTurn, turnBeforeNegativeRow, "Turn should not change after invalid move")
        
        // Test negative column
        let negativeColPos = Position(row: 4, col: -1)
        let turnBeforeNegativeCol = board.isRedTurn
        board.movePiece(from: toPos, to: negativeColPos)
        XCTAssertTrue(board.pieces[toPos.row][toPos.col] === validPiece, "Piece should not move to negative column")
        XCTAssertEqual(board.isRedTurn, turnBeforeNegativeCol, "Turn should not change after invalid move")
        
        // Test too large row
        let tooLargeRowPos = Position(row: 10, col: 0)
        let turnBeforeTooLargeRow = board.isRedTurn
        board.movePiece(from: toPos, to: tooLargeRowPos)
        XCTAssertTrue(board.pieces[toPos.row][toPos.col] === validPiece, "Piece should not move to row >= 10")
        XCTAssertEqual(board.isRedTurn, turnBeforeTooLargeRow, "Turn should not change after invalid move")
        
        // Test too large column
        let tooLargeColPos = Position(row: 4, col: 9)
        let turnBeforeTooLargeCol = board.isRedTurn
        board.movePiece(from: toPos, to: tooLargeColPos)
        XCTAssertTrue(board.pieces[toPos.row][toPos.col] === validPiece, "Piece should not move to column >= 9")
        XCTAssertEqual(board.isRedTurn, turnBeforeTooLargeCol, "Turn should not change after invalid move")
        
        // Test invalid from position
        let invalidFromPos2 = Position(row: 10, col: 0)
        let turnBeforeInvalidFrom = board.isRedTurn
        board.movePiece(from: invalidFromPos2, to: toPos)
        XCTAssertTrue(board.pieces[toPos.row][toPos.col] === validPiece, "Piece should not move from invalid position")
        XCTAssertEqual(board.isRedTurn, turnBeforeInvalidFrom, "Turn should not change after invalid move")
    }
    
    func testPieceCapture() {
        // Setup capture scenario
        let redPawnPos = Position(row: 3, col: 0)
        let bluePawnPos = Position(row: 4, col: 1)
        let bluePawn = Pawn(isRed: false, position: bluePawnPos)
        board.pieces[4][1] = bluePawn
        
        // Perform capture
        let redPawn = board.pieces[redPawnPos.row][redPawnPos.col]
        board.movePiece(from: redPawnPos, to: bluePawnPos)
        XCTAssertTrue(board.capturedBluePieces.contains { $0 === bluePawn }, "Captured piece should be added to captured pieces")
        XCTAssertNil(board.pieces[redPawnPos.row][redPawnPos.col], "Original position should be empty")
        XCTAssertTrue(board.pieces[bluePawnPos.row][bluePawnPos.col] === redPawn, "Capturing piece should be at new position")
    }
    
    func testSelectPiece() {
        // Test selecting valid piece
        let validPosition = Position(row: 3, col: 0)
        board.selectPiece(at: validPosition)
        XCTAssertEqual(board.selectedPiece, validPosition, "Selected piece should be set")
        XCTAssertFalse(board.validMoves.isEmpty, "Valid moves should be calculated")
        
        // Test selecting opponent's piece
        let opponentPosition = Position(row: 6, col: 0)
        board.selectPiece(at: opponentPosition)
        XCTAssertNil(board.selectedPiece, "Should not select opponent's piece")
        XCTAssertTrue(board.validMoves.isEmpty, "Valid moves should be empty")
        
        // Test selecting empty square
        let emptyPosition = Position(row: 4, col: 4)
        board.selectPiece(at: emptyPosition)
        XCTAssertNil(board.selectedPiece, "Should not select empty square")
        XCTAssertTrue(board.validMoves.isEmpty, "Valid moves should be empty")
    }
    
    func testGameStateTransitions() {
        // Test check state
        print("\n=== Testing Check State ===")
        board.setupBoard() // Reset board before each test
        
        // Move pieces to create a check situation
        let redPawnMove = board.movePiece(from: Position(row: 3, col: 0), to: Position(row: 4, col: 0)) // Red pawn
        XCTAssertNil(redPawnMove, "No piece should be captured")
        print("After red pawn move - Game state: \(board.gameState)")
        
        let bluePawnMove = board.movePiece(from: Position(row: 6, col: 0), to: Position(row: 5, col: 0)) // Blue pawn
        XCTAssertNil(bluePawnMove, "No piece should be captured")
        print("After blue pawn move - Game state: \(board.gameState)")
        
        let redChariotMove = board.movePiece(from: Position(row: 0, col: 0), to: Position(row: 1, col: 0)) // Red chariot
        XCTAssertNil(redChariotMove, "No piece should be captured")
        print("After red chariot move - Game state: \(board.gameState)")
        
        let bluePawnMove2 = board.movePiece(from: Position(row: 5, col: 0), to: Position(row: 4, col: 0)) // Blue pawn
        XCTAssertNil(bluePawnMove2, "No piece should be captured")
        print("After blue chariot move - Game state: \(board.gameState)")
        
        let redChariotCheckMove = board.movePiece(from: Position(row: 1, col: 0), to: Position(row: 8, col: 4)) // Red chariot check move
        XCTAssertNil(redChariotCheckMove, "No piece should be captured")
        print("After red chariot check move - Game state: \(board.gameState)")
        
        // Verify check state
        print("Is blue general in check? \(board.isGeneralInCheck(for: .blue))")
        if let blueGeneral = board.pieceAt(Position(row: 9, col: 4)) {
            print("Blue general position: \(blueGeneral.currentPosition)")
        }
        if let redChariot = board.pieceAt(Position(row: 8, col: 4)) {
            print("Red chariot position: \(redChariot.currentPosition)")
        }
        XCTAssertEqual(board.gameState, .check, "Game should be in check state")
        
        // Test checkmate state
        print("\n=== Testing Checkmate State ===")
        board.setupBoard() // Reset board before each test
        
        // Move pieces to create a checkmate situation
        let redPawnMove2 = board.movePiece(from: Position(row: 3, col: 0), to: Position(row: 4, col: 0)) // Red pawn
        XCTAssertNil(redPawnMove2, "No piece should be captured")
        print("After red pawn move - Game state: \(board.gameState)")
        
        let bluePawnMove3 = board.movePiece(from: Position(row: 6, col: 0), to: Position(row: 5, col: 0)) // Blue pawn
        XCTAssertNil(bluePawnMove3, "No piece should be captured")
        print("After blue pawn move - Game state: \(board.gameState)")
        
        let redChariotMove2 = board.movePiece(from: Position(row: 0, col: 0), to: Position(row: 1, col: 0)) // Red chariot
        XCTAssertNil(redChariotMove2, "No piece should be captured")
        print("After red chariot move - Game state: \(board.gameState)")
        
        let bluePawnMove4 = board.movePiece(from: Position(row: 5, col: 0), to: Position(row: 4, col: 0)) // Blue pawn
        XCTAssertNil(bluePawnMove4, "No piece should be captured")
        print("After blue chariot move - Game state: \(board.gameState)")
        
        let redChariotCheckMove2 = board.movePiece(from: Position(row: 1, col: 0), to: Position(row: 8, col: 4)) // Red chariot check move
        XCTAssertNil(redChariotCheckMove2, "No piece should be captured")
        print("After red chariot check move - Game state: \(board.gameState)")
        
        // Verify checkmate state
        print("Is blue general in check? \(board.isGeneralInCheck(for: .blue))")
        print("Is checkmate? \(board.isCheckmate(for: .blue))")
        if let blueGeneral = board.pieceAt(Position(row: 9, col: 4)) {
            print("Blue general position: \(blueGeneral.currentPosition)")
        }
        if let redChariot = board.pieceAt(Position(row: 8, col: 4)) {
            print("Red chariot position: \(redChariot.currentPosition)")
        }
        XCTAssertEqual(board.gameState, .checkmate, "Game should be in checkmate state")
        
        // Test bikjang state
        print("\n=== Testing Bikjang State ===")
        board.setupBoard() // Reset board before each test
        
        // Move generals to center column
        let redGeneralMove = board.movePiece(from: Position(row: 0, col: 4), to: Position(row: 4, col: 4)) // Red general
        XCTAssertNil(redGeneralMove, "No piece should be captured")
        print("After red general move - Game state: \(board.gameState)")
        
        let blueGeneralMove = board.movePiece(from: Position(row: 9, col: 4), to: Position(row: 5, col: 4)) // Blue general
        XCTAssertNil(blueGeneralMove, "No piece should be captured")
        print("After blue general move - Game state: \(board.gameState)")
        
        // Verify bikjang state
        print("Is bikjang? \(board.isBikjang())")
        if let redGeneral = board.pieceAt(Position(row: 4, col: 4)) {
            print("Red general position: \(redGeneral.currentPosition)")
        }
        if let blueGeneral = board.pieceAt(Position(row: 5, col: 4)) {
            print("Blue general position: \(blueGeneral.currentPosition)")
        }
        XCTAssertEqual(board.gameState, .stalemate, "Game should be in stalemate state")
        
        // Test breaking bikjang
        let redGeneralMove2 = board.movePiece(from: Position(row: 4, col: 4), to: Position(row: 4, col: 3)) // Red general
        XCTAssertNil(redGeneralMove2, "No piece should be captured")
        print("After breaking bikjang - Game state: \(board.gameState)")
        print("Is bikjang? \(board.isBikjang())")
        if let redGeneral = board.pieceAt(Position(row: 4, col: 3)) {
            print("Red general position: \(redGeneral.currentPosition)")
        }
        if let blueGeneral = board.pieceAt(Position(row: 5, col: 4)) {
            print("Blue general position: \(blueGeneral.currentPosition)")
        }
        XCTAssertEqual(board.gameState, .playing, "Game should return to playing state")
        
        // Test stalemate state
        print("\n=== Testing Stalemate State ===")
        board.setupBoard() // Reset board before each test
        
        // Move pieces to create a stalemate situation
        let redGuardMove = board.movePiece(from: Position(row: 0, col: 3), to: Position(row: 1, col: 4)) // Red guard
        XCTAssertNil(redGuardMove, "No piece should be captured")
        print("After red guard move - Game state: \(board.gameState)")
        
        let blueGuardMove = board.movePiece(from: Position(row: 9, col: 3), to: Position(row: 8, col: 4)) // Blue guard
        XCTAssertNil(blueGuardMove, "No piece should be captured")
        print("After blue guard move - Game state: \(board.gameState)")
        
        // Move guards to positions where they can't move without putting their general in check
        let redGuardMove2 = board.movePiece(from: Position(row: 1, col: 4), to: Position(row: 2, col: 4)) // Red guard
        XCTAssertNil(redGuardMove2, "No piece should be captured")
        print("After red guard second move - Game state: \(board.gameState)")
        
        let blueGuardMove2 = board.movePiece(from: Position(row: 8, col: 4), to: Position(row: 7, col: 4)) // Blue guard
        XCTAssertNil(blueGuardMove2, "No piece should be captured")
        print("After blue guard second move - Game state: \(board.gameState)")
        
        // Move guards to final positions where no legal moves are possible
        let redGuardMove3 = board.movePiece(from: Position(row: 2, col: 4), to: Position(row: 3, col: 4)) // Red guard
        XCTAssertNil(redGuardMove3, "No piece should be captured")
        print("After red guard final move - Game state: \(board.gameState)")
        
        let blueGuardMove3 = board.movePiece(from: Position(row: 7, col: 4), to: Position(row: 6, col: 4)) // Blue guard
        XCTAssertNil(blueGuardMove3, "No piece should be captured")
        print("After blue guard final move - Game state: \(board.gameState)")
        
        // Verify that neither general is in check
        XCTAssertFalse(board.isGeneralInCheck(for: .red), "Red general should not be in check")
        XCTAssertFalse(board.isGeneralInCheck(for: .blue), "Blue general should not be in check")
        
        // Print final piece positions
        print("\nFinal piece positions:")
        for row in 0..<10 {
            for col in 0..<9 {
                if let piece = board.pieceAt(Position(row: row, col: col)) {
                    print("\(piece.imageName) at (\(row), \(col))")
                }
            }
        }
        
        // Verify stalemate state
        print("Is stalemate? \(board.isStalemate())")
        if let redGeneral = board.pieceAt(Position(row: 0, col: 4)) {
            print("Red general position: \(redGeneral.currentPosition)")
        }
        if let blueGeneral = board.pieceAt(Position(row: 9, col: 4)) {
            print("Blue general position: \(blueGeneral.currentPosition)")
        }
        XCTAssertTrue(board.isStalemate(), "Game should be in stalemate state")
        XCTAssertEqual(board.gameState, .stalemate, "Game should be in stalemate state")
    }
    
    func testBoardReset() {
        // Make moves for both players
        // Red's move
        let redFromPos = Position(row: 3, col: 0)
        let redToPos = Position(row: 4, col: 0)
        guard let redPiece = board.pieces[redFromPos.row][redFromPos.col] else {
            XCTFail("Red piece should exist at start position")
            return
        }
        print("Initial red piece type: \(type(of: redPiece))")
        let redPieceType = type(of: redPiece)
        board.movePiece(from: redFromPos, to: redToPos)
        
        // Blue's move
        let blueFromPos = Position(row: 6, col: 0)
        let blueToPos = Position(row: 5, col: 0)
        guard let bluePiece = board.pieces[blueFromPos.row][blueFromPos.col] else {
            XCTFail("Blue piece should exist at start position")
            return
        }
        print("Initial blue piece type: \(type(of: bluePiece))")
        let bluePieceType = type(of: bluePiece)
        board.movePiece(from: blueFromPos, to: blueToPos)
        
        // Capture a piece
        let captureFromPos = Position(row: 4, col: 0)
        let captureToPos = Position(row: 5, col: 0)
        guard let capturedPiece = board.pieces[captureToPos.row][captureToPos.col] else {
            XCTFail("Piece to be captured should exist")
            return
        }
        print("Initial captured piece type: \(type(of: capturedPiece))")
        let capturedPieceType = type(of: capturedPiece)
        board.movePiece(from: captureFromPos, to: captureToPos)
        
        // Select a piece
        let selectPos = Position(row: 0, col: 0)
        board.selectPiece(at: selectPos)
        
        // Reset board
        board.setupBoard()
        
        // Verify board is back to initial state
        // Check piece positions and types
        guard let resetRedPiece = board.pieces[redFromPos.row][redFromPos.col] else {
            XCTFail("Red piece should be at original position after reset")
            return
        }
        print("Reset red piece type: \(type(of: resetRedPiece))")
        XCTAssertTrue(type(of: resetRedPiece) == redPieceType, "Red piece should be of same type")
        XCTAssertNil(board.pieces[redToPos.row][redToPos.col], "Red piece should not be at moved position")
        
        guard let resetBluePiece = board.pieces[blueFromPos.row][blueFromPos.col] else {
            XCTFail("Blue piece should be at original position after reset")
            return
        }
        print("Reset blue piece type: \(type(of: resetBluePiece))")
        XCTAssertTrue(type(of: resetBluePiece) == bluePieceType, "Blue piece should be of same type")
        XCTAssertNil(board.pieces[blueToPos.row][blueToPos.col], "Blue piece should not be at moved position")
        
        // Check the original position of the captured piece
        let originalCapturePos = Position(row: 6, col: 0) // This is where the blue pawn started
        guard let resetCapturedPiece = board.pieces[originalCapturePos.row][originalCapturePos.col] else {
            XCTFail("Captured piece should be at original position after reset")
            return
        }
        print("Reset captured piece type: \(type(of: resetCapturedPiece))")
        XCTAssertTrue(type(of: resetCapturedPiece) == capturedPieceType, "Captured piece should be of same type")
        
        // Check game state
        XCTAssertTrue(board.isRedTurn, "Turn should be reset to red")
        XCTAssertEqual(board.gameState, .playing, "Game state should be reset to playing")
        XCTAssertTrue(board.capturedRedPieces.isEmpty, "Captured red pieces should be cleared")
        XCTAssertTrue(board.capturedBluePieces.isEmpty, "Captured blue pieces should be cleared")
        XCTAssertNil(board.selectedPiece, "Selected piece should be cleared")
        XCTAssertTrue(board.validMoves.isEmpty, "Valid moves should be cleared")
        
        // Verify initial piece positions
        XCTAssertNotNil(board.pieces[0][0], "Red chariot should be at (0,0)")
        XCTAssertNotNil(board.pieces[0][1], "Red horse should be at (0,1)")
        XCTAssertNotNil(board.pieces[0][2], "Red elephant should be at (0,2)")
        XCTAssertNotNil(board.pieces[0][3], "Red guard should be at (0,3)")
        XCTAssertNotNil(board.pieces[0][4], "Red general should be at (0,4)")
        XCTAssertNotNil(board.pieces[0][5], "Red guard should be at (0,5)")
        XCTAssertNotNil(board.pieces[0][6], "Red elephant should be at (0,6)")
        XCTAssertNotNil(board.pieces[0][7], "Red horse should be at (0,7)")
        XCTAssertNotNil(board.pieces[0][8], "Red chariot should be at (0,8)")
        
        XCTAssertNotNil(board.pieces[9][0], "Blue chariot should be at (9,0)")
        XCTAssertNotNil(board.pieces[9][1], "Blue horse should be at (9,1)")
        XCTAssertNotNil(board.pieces[9][2], "Blue elephant should be at (9,2)")
        XCTAssertNotNil(board.pieces[9][3], "Blue guard should be at (9,3)")
        XCTAssertNotNil(board.pieces[9][4], "Blue general should be at (9,4)")
        XCTAssertNotNil(board.pieces[9][5], "Blue guard should be at (9,5)")
        XCTAssertNotNil(board.pieces[9][6], "Blue elephant should be at (9,6)")
        XCTAssertNotNil(board.pieces[9][7], "Blue horse should be at (9,7)")
        XCTAssertNotNil(board.pieces[9][8], "Blue chariot should be at (9,8)")
    }
} 