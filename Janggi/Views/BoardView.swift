import SwiftUI

struct BoardView: View {
    @ObservedObject var board: Board
    @ObservedObject var settings: Settings
    let squareSize: CGFloat
    let onSquareTap: (Position) -> Void
    
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
                    BoardGridView(board: board, settings: settings, grid: grid, onSquareTap: onSquareTap)
                    // Top palace: center at (1,4) in grid lines
                    PalaceView(size: cellSize * 2)
                        .frame(width: cellSize * 2, height: cellSize * 2)
                        .position(x: cellSize * 4, y: cellSize * 1)
                    // Bottom palace: center at (8,4) in grid lines
                    PalaceView(size: cellSize * 2)
                        .frame(width: cellSize * 2, height: cellSize * 2)
                        .position(x: cellSize * 4, y: cellSize * 8)
                    // Pieces (should be on top)
                    PieceGridView(board: board, settings: settings, grid: grid, onSquareTap: onSquareTap)
                }
                .frame(width: boardWidth, height: boardHeight)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BoardView(board: Board(), settings: Settings(), squareSize: 40, onSquareTap: { _ in })
            horseCaptureTest
            moveIndicatorsTest
            elephantMovementTest
        }
    }

    static var horseCaptureTest: some View {
        let testBoard = Board()
        for row in 0..<10 { for col in 0..<9 { testBoard.pieces[row][col] = nil } }
        testBoard.pieces[4][5] = Horse(isRed: true, position: Position(row: 4, col: 5))
        testBoard.pieces[2][6] = Soldier(isRed: false, position: Position(row: 2, col: 6))
        return BoardView(board: testBoard, settings: Settings(), squareSize: 40, onSquareTap: { _ in })
    }

    static var moveIndicatorsTest: some View {
        let testBoard = Board()
        for row in 0..<10 { for col in 0..<9 { testBoard.pieces[row][col] = nil } }
        testBoard.pieces[4][4] = Chariot(isRed: true, position: Position(row: 4, col: 4))
        testBoard.selectedPiece = testBoard.pieces[4][4]
        testBoard.validMoves = [
            Position(row: 0, col: 4), Position(row: 1, col: 4), Position(row: 2, col: 4), Position(row: 3, col: 4),
            Position(row: 5, col: 4), Position(row: 6, col: 4), Position(row: 7, col: 4), Position(row: 8, col: 4), Position(row: 9, col: 4),
            Position(row: 4, col: 0), Position(row: 4, col: 1), Position(row: 4, col: 2), Position(row: 4, col: 3),
            Position(row: 4, col: 5), Position(row: 4, col: 6), Position(row: 4, col: 7), Position(row: 4, col: 8)
        ]
        return BoardView(board: testBoard, settings: Settings(), squareSize: 40, onSquareTap: { _ in })
    }

    static var elephantMovementTest: some View {
        let testBoard = Board()
        for row in 0..<10 { for col in 0..<9 { testBoard.pieces[row][col] = nil } }
        testBoard.pieces[4][4] = Elephant(isRed: true, position: Position(row: 4, col: 4))
        testBoard.selectedPiece = testBoard.pieces[4][4]
        testBoard.validMoves = [
            Position(row: 2, col: 6), Position(row: 2, col: 2), Position(row: 6, col: 6), Position(row: 6, col: 2)
        ]
        return BoardView(board: testBoard, settings: Settings(), squareSize: 40, onSquareTap: { _ in })
    }
} 
