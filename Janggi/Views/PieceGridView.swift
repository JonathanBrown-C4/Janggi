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
                    
                    // Check if this piece is a general in check
                    let isInCheck = (piece.imageName == "red_general" && board.redGeneralInCheck) ||
                                   (piece.imageName == "blue_general" && board.blueGeneralInCheck)
                    
                    // Check if this piece is selected
                    let isSelected = board.selectedPiece?.row == row && board.selectedPiece?.col == col
                    
                    // Check if this piece is capturable
                    let isCapturable = board.capturablePieces.contains(where: { $0.row == row && $0.col == col })
                    
                    PieceView(piece: piece, isInCheck: isInCheck, isSelected: isSelected, isCapturable: isCapturable)
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
