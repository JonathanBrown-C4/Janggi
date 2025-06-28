import CoreGraphics

struct GridGeometry {
    let columns: Int
    let rows: Int
    let cellSize: CGFloat

    // Returns the CGPoint for a given board position (intersection)
    func point(for position: Position) -> CGPoint {
        CGPoint(x: CGFloat(position.col) * cellSize, y: CGFloat(position.row) * cellSize)
    }

    // Returns the board position for a given CGPoint (if within bounds)
    func position(for point: CGPoint) -> Position? {
        let col = Int(round(point.x / cellSize))
        let row = Int(round(point.y / cellSize))
        guard row >= 0, row < rows, col >= 0, col < columns else { return nil }
        return Position(row: row, col: col)
    }

    // Board size in points
    var boardSize: CGSize {
        CGSize(width: CGFloat(columns - 1) * cellSize, height: CGFloat(rows - 1) * cellSize)
    }
} 