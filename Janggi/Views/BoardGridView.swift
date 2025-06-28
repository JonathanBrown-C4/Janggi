import SwiftUI

struct BoardGridView: View {
    @ObservedObject var board: Board
    let grid: GridGeometry
    let onSquareTap: (Position) -> Void
    
    // Star point positions (row, col) as intersection points
    private let starPoints: [(Int, Int)] = [
        (2,1), (2,7),
        (3,0), (3,2), (3,4), (3,6), (3,8),
        (6,0), (6,2), (6,4), (6,6), (6,8),
        (7,1), (7,7)
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Draw grid lines
                Path { path in
                    // Vertical lines
                    for col in 0..<grid.columns {
                        let x = CGFloat(col) * grid.cellSize
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: geo.size.height))
                    }
                    // Horizontal lines
                    for row in 0..<grid.rows {
                        let y = CGFloat(row) * grid.cellSize
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geo.size.width, y: y))
                    }
                }
                .stroke(Color.black, lineWidth: 2)
                // Draw star points (now 16x16)
                ForEach(Array(starPoints.enumerated()), id: \.offset) { _, point in
                    let pos = grid.point(for: Position(row: point.0, col: point.1))
                    Circle()
                        .fill(Color.black)
                        .frame(width: 16, height: 16)
                        .position(x: pos.x, y: pos.y)
                }
                // Overlay pieces and tap logic
                VStack(spacing: 0) {
                    ForEach(0..<(grid.rows-1)) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<(grid.columns-1)) { col in
                                let position = Position(row: row, col: col)
                                SquareView(
                                    position: position,
                                    squareSize: grid.cellSize,
                                    isSelected: board.selectedPiece == position,
                                    isValidMove: board.validMoves.contains(where: { $0.row == row && $0.col == col }),
                                    onTap: { onSquareTap(position) }
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    BoardGridView(
        board: Board(),
        grid: GridGeometry(columns: 9, rows: 10, cellSize: 40),
        onSquareTap: { _ in }
    )
    .padding()
} 