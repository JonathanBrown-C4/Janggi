import SwiftUI

struct PieceGridView: View {
    @ObservedObject var board: Board
    @ObservedObject var settings: Settings
    let grid: GridGeometry
    let onSquareTap: (Position) -> Void
    
    private var pieceViews: some View {
        ForEach(Array(0..<grid.rows), id: \.self) { row in
            ForEach(Array(0..<grid.columns), id: \.self) { col in
                if let piece = board.pieces[row][col] {
                    pieceView(for: piece, at: Position(row: row, col: col))
                }
            }
        }
    }
    
    private func pieceView(for piece: Piece, at position: Position) -> some View {
        let y = CGFloat(position.row) * grid.cellSize
        let x = CGFloat(position.col) * grid.cellSize
        
        // Check if this piece is a general in check
        let isInCheck = (piece.imageName == "red_general" && board.redGeneralInCheck) ||
                       (piece.imageName == "blue_general" && board.blueGeneralInCheck)
        
        // Check if this piece is selected
        let isSelected = board.selectedPiece?.currentPosition == position
        
        // Check if this piece is capturable
        let isCapturable = board.capturablePieces.contains(where: { $0 == position })
        
        return PieceView(piece: piece, settings: settings, isInCheck: isInCheck, isSelected: isSelected, isCapturable: isCapturable)
            .position(x: x, y: y)
            .onTapGesture {
                onSquareTap(position)
            }
    }
    
    var body: some View {
        pieceViews
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
            settings: Settings(),
            grid: grid,
            onSquareTap: { _ in }
        )
    }
    .padding()
} 
