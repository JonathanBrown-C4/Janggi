import SwiftUI

struct MinimalistPieceView: View {
    let piece: Piece
    let isRed: Bool
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(isRed ? Color.red : Color.blue)
                .frame(width: 40, height: 40)
            
            // Piece icon
            pieceIcon
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
        }
    }
    
    @ViewBuilder
    private var pieceIcon: some View {
        switch piece.type {
        case .general:
            Image(systemName: "crown.fill")
        case .guard_:
            Image(systemName: "shield.fill")
        case .elephant:
            Image(systemName: "face.smiling.fill")
        case .horse:
            Image(systemName: "hare.fill")
        case .chariot:
            Image(systemName: "car.2.fill")
        case .cannon:
            Image(systemName: "cylinder.fill")
        case .soldier:
            Image(systemName: "person.fill")
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 20) {
            MinimalistPieceView(piece: General(isRed: true, position: Position(row: 0, col: 4)), isRed: true)
            MinimalistPieceView(piece: Guard(isRed: true, position: Position(row: 0, col: 3)), isRed: true)
            MinimalistPieceView(piece: Elephant(isRed: true, position: Position(row: 0, col: 2)), isRed: true)
            MinimalistPieceView(piece: Horse(isRed: true, position: Position(row: 0, col: 1)), isRed: true)
        }
        
        HStack(spacing: 20) {
            MinimalistPieceView(piece: Chariot(isRed: true, isLeft: true), isRed: true)
            MinimalistPieceView(piece: Cannon(isRed: true, position: Position(row: 2, col: 1)), isRed: true)
            MinimalistPieceView(piece: Soldier(isRed: true, position: Position(row: 3, col: 0)), isRed: true)
        }
        
        HStack(spacing: 20) {
            MinimalistPieceView(piece: General(isRed: false, position: Position(row: 8, col: 4)), isRed: false)
            MinimalistPieceView(piece: Guard(isRed: false, position: Position(row: 9, col: 3)), isRed: false)
            MinimalistPieceView(piece: Elephant(isRed: false, position: Position(row: 9, col: 2)), isRed: false)
            MinimalistPieceView(piece: Horse(isRed: false, position: Position(row: 9, col: 1)), isRed: false)
        }
        
        HStack(spacing: 20) {
            MinimalistPieceView(piece: Chariot(isRed: false, isLeft: true), isRed: false)
            MinimalistPieceView(piece: Cannon(isRed: false, position: Position(row: 7, col: 1)), isRed: false)
            MinimalistPieceView(piece: Soldier(isRed: false, position: Position(row: 6, col: 0)), isRed: false)
        }
    }
    .padding()
} 