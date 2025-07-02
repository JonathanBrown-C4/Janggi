import SwiftUI

struct BoardGridView: View {
    @ObservedObject var board: Board
    @ObservedObject var settings: Settings
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
                
                // Draw move indicators as circles at grid intersections (always present for visual feedback)
                ForEach(board.validMoves, id: \.self) { movePosition in
                    let pos = grid.point(for: movePosition)
                    Circle()
                        .fill(settings.showMoveHints ? Color.green.opacity(0.6) : Color.clear)
                        .overlay(
                            Circle()
                                .stroke(settings.showMoveHints ? Color.gray : Color.clear, lineWidth: 2)
                        )
                        .opacity(settings.showMoveHints ? 1 : 0)
                        .frame(width: 26, height: 26)
                        .position(x: pos.x, y: pos.y)
                }
                
                // Draw selected piece indicator (only if move hints are enabled)
                if settings.showMoveHints, let selectedPosition = board.selectedPiece {
                    let pos = grid.point(for: selectedPosition)
                    Circle()
                        .fill(Color.yellow.opacity(0.6))
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        .frame(width: 26, height: 26)
                        .position(x: pos.x, y: pos.y)
                }
                
                // Overlay tap area for piece selection (single transparent layer)
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                let x = value.location.x
                                let y = value.location.y
                                let col = Int(round(x / grid.cellSize))
                                let row = Int(round(y / grid.cellSize))
                                if row >= 0 && row < grid.rows && col >= 0 && col < grid.columns {
                                    onSquareTap(Position(row: row, col: col))
                                }
                            }
                    )
            }
        }
    }
}

#Preview {
    BoardGridView(
        board: Board(),
        settings: Settings(),
        grid: GridGeometry(columns: 9, rows: 10, cellSize: 40),
        onSquareTap: { _ in }
    )
    .padding()
} 