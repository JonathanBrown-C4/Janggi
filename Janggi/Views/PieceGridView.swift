import SwiftUI

struct PieceGridView: View {
    @ObservedObject var board: Board
    let grid: GridGeometry
    let onSquareTap: (Position) -> Void
    
    var body: some View {
        ForEach(0..<grid.rows) { row in
            ForEach(0..<grid.columns) { col in
                if let piece = board.pieces[row][col] {
                    let y = CGFloat(row) * grid.cellSize
                    let x = CGFloat(col) * grid.cellSize
                    PieceView(piece: piece)
                        .position(x: x, y: y)
                        .onTapGesture {
                            onSquareTap(Position(row: row, col: col))
                        }
                }
            }
        }
    }
}

#Preview {
    let grid = GridGeometry(columns: 9, rows: 10, cellSize: 40)
    ZStack {
        Rectangle()
            .fill(Color(red: 0.8, green: 0.7, blue: 0.5))
            .frame(width: grid.cellSize * CGFloat(grid.columns - 1), height: grid.cellSize * CGFloat(grid.rows - 1))
        
        PieceGridView(
            board: Board(),
            grid: grid,
            onSquareTap: { _ in }
        )
    }
    .padding()
} 
