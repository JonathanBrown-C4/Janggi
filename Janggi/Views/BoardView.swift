import SwiftUI

struct BoardView: View {
    @ObservedObject var board: Board
    let squareSize: CGFloat
    
    var body: some View {
        GeometryReader { geo in
            let columns = 9
            let rows = 10
            let cellSize = min(geo.size.width / CGFloat(columns - 1), geo.size.height / CGFloat(rows - 1))
            let grid = GridGeometry(columns: columns, rows: rows, cellSize: cellSize)
            let boardWidth = cellSize * CGFloat(columns - 1)
            let boardHeight = cellSize * CGFloat(rows - 1)
            VStack {
                Spacer()
                ZStack {
                    // Board background
                    Color(red: 0.8, green: 0.7, blue: 0.5)
                    // Grid, star points, and tap overlays
                    BoardGridView(board: board, grid: grid, onSquareTap: handleSquareTap)
                    // Top palace: center at (1,4) in grid lines
                    PalaceView(size: cellSize * 2)
                        .frame(width: cellSize * 2, height: cellSize * 2)
                        .position(x: cellSize * 4, y: cellSize * 1)
                    // Bottom palace: center at (8,4) in grid lines
                    PalaceView(size: cellSize * 2)
                        .frame(width: cellSize * 2, height: cellSize * 2)
                        .position(x: cellSize * 4, y: cellSize * 8)
                    // Pieces (should be on top)
                    PieceGridView(board: board, grid: grid, onSquareTap: handleSquareTap)
                }
                .frame(width: boardWidth, height: boardHeight)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
    
    private func handleSquareTap(at position: Position) {
        if let selectedPiece = board.selectedPiece {
            if board.validMoves.contains(where: { $0.row == position.row && $0.col == position.col }) {
                _ = board.movePiece(from: selectedPiece, to: position)
            } else {
                board.selectedPiece = nil
                board.validMoves = []
            }
        } else {
            board.selectPiece(at: position)
        }
    }
}

#Preview {
    BoardView(board: Board(), squareSize: 40)
}

#Preview("Horse Capture Test") {
    let testBoard = Board()
    // Clear the board
    for row in 0..<10 {
        for col in 0..<9 {
            testBoard.pieces[row][col] = nil
        }
    }
    // Set up the test scenario: Horse at (4,5), Soldier at (2,6)
    testBoard.pieces[4][5] = Horse(isRed: true, position: Position(row: 4, col: 5))
    testBoard.pieces[2][6] = Soldier(isRed: false, position: Position(row: 2, col: 6))
    
    return BoardView(board: testBoard, squareSize: 40)
}

#Preview("Move Indicators Test") {
    let testBoard = Board()
    // Clear the board
    for row in 0..<10 {
        for col in 0..<9 {
            testBoard.pieces[row][col] = nil
        }
    }
    // Set up a scenario to show move indicators
    testBoard.pieces[4][4] = Chariot(isRed: true, position: Position(row: 4, col: 4))
    testBoard.selectedPiece = Position(row: 4, col: 4)
    testBoard.validMoves = [
        Position(row: 0, col: 4), // Up
        Position(row: 1, col: 4), // Up
        Position(row: 2, col: 4), // Up
        Position(row: 3, col: 4), // Up
        Position(row: 5, col: 4), // Down
        Position(row: 6, col: 4), // Down
        Position(row: 7, col: 4), // Down
        Position(row: 8, col: 4), // Down
        Position(row: 9, col: 4), // Down
        Position(row: 4, col: 0), // Left
        Position(row: 4, col: 1), // Left
        Position(row: 4, col: 2), // Left
        Position(row: 4, col: 3), // Left
        Position(row: 4, col: 5), // Right
        Position(row: 4, col: 6), // Right
        Position(row: 4, col: 7), // Right
        Position(row: 4, col: 8)  // Right
    ]
    
    return BoardView(board: testBoard, squareSize: 40)
}

#Preview("Elephant Movement Test") {
    let testBoard = Board()
    // Clear the board
    for row in 0..<10 {
        for col in 0..<9 {
            testBoard.pieces[row][col] = nil
        }
    }
    // Set up Elephant at center to test movement
    testBoard.pieces[4][4] = Elephant(isRed: true, position: Position(row: 4, col: 4))
    testBoard.selectedPiece = Position(row: 4, col: 4)
    
    // Manually set the expected Elephant moves (diagonal 2 steps)
    testBoard.validMoves = [
        Position(row: 2, col: 6), // Up-right (diagonal 2 steps)
        Position(row: 2, col: 2), // Up-left (diagonal 2 steps)
        Position(row: 6, col: 6), // Down-right (diagonal 2 steps)
        Position(row: 6, col: 2)  // Down-left (diagonal 2 steps)
    ]
    
    return BoardView(board: testBoard, squareSize: 40)
}

#Preview("Elephant Movement Debug") {
    let testBoard = Board()
    // Clear the board
    for row in 0..<10 {
        for col in 0..<9 {
            testBoard.pieces[row][col] = nil
        }
    }
    // Set up Elephant at center to test movement
    let elephant = Elephant(isRed: true, position: Position(row: 4, col: 4))
    testBoard.pieces[4][4] = elephant
    testBoard.selectedPiece = Position(row: 4, col: 4)
    
    // Get actual moves from the board
    let actualMoves = testBoard.validMoves(for: elephant)
    print("Actual Elephant moves: \(actualMoves)")
    
    // Expected moves (diagonal 2 steps)
    let expectedMoves = [
        Position(row: 2, col: 6), // Up-right (diagonal 2 steps)
        Position(row: 2, col: 2), // Up-left (diagonal 2 steps)
        Position(row: 6, col: 6), // Down-right (diagonal 2 steps)
        Position(row: 6, col: 2)  // Down-left (diagonal 2 steps)
    ]
    print("Expected Elephant moves: \(expectedMoves)")
    
    testBoard.validMoves = actualMoves
    
    return BoardView(board: testBoard, squareSize: 40)
} 
