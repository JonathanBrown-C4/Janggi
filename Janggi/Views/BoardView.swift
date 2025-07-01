import SwiftUI

struct BoardView: View {
    @ObservedObject var board: Board
    @ObservedObject var settings: Settings
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
                    BoardGridView(board: board, settings: settings, grid: grid, onSquareTap: handleSquareTap)
                    // Top palace: center at (1,4) in grid lines
                    PalaceView(size: cellSize * 2)
                        .frame(width: cellSize * 2, height: cellSize * 2)
                        .position(x: cellSize * 4, y: cellSize * 1)
                    // Bottom palace: center at (8,4) in grid lines
                    PalaceView(size: cellSize * 2)
                        .frame(width: cellSize * 2, height: cellSize * 2)
                        .position(x: cellSize * 4, y: cellSize * 8)
                    // Pieces (should be on top)
                    PieceGridView(board: board, settings: settings, grid: grid, onSquareTap: handleSquareTap)
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
    BoardView(board: Board(), settings: Settings(), squareSize: 40)
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
    
    return BoardView(board: testBoard, settings: Settings(), squareSize: 40)
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
    
    return BoardView(board: testBoard, settings: Settings(), squareSize: 40)
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
    
    return BoardView(board: testBoard, settings: Settings(), squareSize: 40)
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
    
    // Check for orthogonal moves (which should NOT exist)
    let orthogonalMoves = actualMoves.filter { move in
        let rowDiff = abs(move.row - 4)
        let colDiff = abs(move.col - 4)
        return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1)
    }
    
    if !orthogonalMoves.isEmpty {
        print("ERROR: Elephant has orthogonal moves: \(orthogonalMoves)")
    }
    
    // Show actual moves in the UI
    testBoard.validMoves = actualMoves
    
    return VStack {
        Text("Elephant at (4,4)")
            .font(.headline)
        Text("Actual moves: \(actualMoves.count)")
            .foregroundColor(orthogonalMoves.isEmpty ? .green : .red)
        Text("Expected: 4 diagonal moves only")
            .font(.caption)
        BoardView(board: testBoard, settings: Settings(), squareSize: 40)
    }
}

#Preview("Elephant Rules Debug") {
    let elephant = Elephant(isRed: true, position: Position(row: 4, col: 4))
    
    return VStack {
        Text("Elephant Movement Rules")
            .font(.headline)
        
        ForEach(Array(elephant.movementRules.enumerated()), id: \.offset) { index, rule in
            VStack(alignment: .leading) {
                Text("Rule \(index):")
                    .font(.subheadline)
                Text("Direction: \(String(describing: rule.direction))")
                Text("Max Distance: \(rule.maxDistance)")
                Text("Blocking Rules: \(String(describing: rule.blockingRules))")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        
        Text("Total rules: \(elephant.movementRules.count)")
            .font(.caption)
    }
    .padding()
}

#Preview("Elephant Move Analysis") {
    let testBoard = Board()
    // Clear the board
    for row in 0..<10 {
        for col in 0..<9 {
            testBoard.pieces[row][col] = nil
        }
    }
    // Set up Elephant at center
    let elephant = Elephant(isRed: true, position: Position(row: 4, col: 4))
    testBoard.pieces[4][4] = elephant
    testBoard.selectedPiece = Position(row: 4, col: 4)
    
    // Get actual moves
    let actualMoves = testBoard.validMoves(for: elephant)
    
    // Categorize moves
    let orthogonalMoves = actualMoves.filter { move in
        let rowDiff = abs(move.row - 4)
        let colDiff = abs(move.col - 4)
        return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1)
    }
    
    let diagonalMoves = actualMoves.filter { move in
        let rowDiff = abs(move.row - 4)
        let colDiff = abs(move.col - 4)
        return rowDiff == colDiff && rowDiff > 0
    }
    
    let otherMoves = actualMoves.filter { move in
        let rowDiff = abs(move.row - 4)
        let colDiff = abs(move.col - 4)
        return !((rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1)) && !(rowDiff == colDiff && rowDiff > 0)
    }
    
    return VStack {
        Text("Elephant Move Analysis")
            .font(.headline)
        
        Text("Total moves: \(actualMoves.count)")
            .font(.subheadline)
        
        if !orthogonalMoves.isEmpty {
            Text("ORTHOGONAL MOVES (1 step): \(orthogonalMoves.count)")
                .foregroundColor(.red)
                .font(.caption)
            ForEach(orthogonalMoves, id: \.self) { move in
                Text("  \(move.row),\(move.col)")
                    .font(.caption)
            }
        }
        
        if !diagonalMoves.isEmpty {
            Text("DIAGONAL MOVES (2+ steps): \(diagonalMoves.count)")
                .foregroundColor(.green)
                .font(.caption)
            ForEach(diagonalMoves, id: \.self) { move in
                Text("  \(move.row),\(move.col)")
                    .font(.caption)
            }
        }
        
        if !otherMoves.isEmpty {
            Text("OTHER MOVES: \(otherMoves.count)")
                .foregroundColor(.orange)
                .font(.caption)
            ForEach(otherMoves, id: \.self) { move in
                Text("  \(move.row),\(move.col)")
                    .font(.caption)
            }
        }
        
        BoardView(board: testBoard, settings: Settings(), squareSize: 30)
    }
    .padding()
} 
