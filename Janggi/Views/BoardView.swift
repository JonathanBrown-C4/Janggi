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
        .previewDisplayName("Horse at (4,5) can capture Soldier at (2,6)")
} 
