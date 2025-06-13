import SwiftUI

struct BoardGridView: View {
    @ObservedObject var board: Board
    let squareSize: CGFloat
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
            let columns = 8
            let rows = 9
            let gridCols = columns + 1 // 9 columns of lines
            let gridRows = rows + 1    // 10 rows of lines
            let width = geo.size.width
            let height = geo.size.height
            let cellWidth = width / CGFloat(columns)
            let cellHeight = height / CGFloat(rows)
            ZStack {
                // Draw grid lines
                Path { path in
                    // Vertical lines
                    for col in 0..<gridCols {
                        let x = CGFloat(col) * cellWidth
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: height))
                    }
                    // Horizontal lines
                    for row in 0..<gridRows {
                        let y = CGFloat(row) * cellHeight
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                }
                .stroke(Color.black, lineWidth: 2)
                // Draw star points (now 16x16)
                ForEach(Array(starPoints.enumerated()), id: \.offset) { _, point in
                    Circle()
                        .fill(Color.black)
                        .frame(width: 16, height: 16)
                        .position(x: CGFloat(point.1) * cellWidth, y: CGFloat(point.0) * cellHeight)
                }
                // Overlay pieces and tap logic
                VStack(spacing: 0) {
                    ForEach(0..<rows) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<columns) { col in
                                let position = Position(row: row, col: col)
                                SquareView(
                                    position: position,
                                    squareSize: min(cellWidth, cellHeight),
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
        squareSize: 40,
        onSquareTap: { _ in }
    )
    .padding()
} 