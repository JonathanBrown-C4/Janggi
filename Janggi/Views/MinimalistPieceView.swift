import SwiftUI

// Custom Cannon Shape
struct CannonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Barrel
        path.addRoundedRect(in: CGRect(x: rect.minX + rect.width * 0.2, y: rect.midY - rect.height * 0.13, width: rect.width * 0.55, height: rect.height * 0.25), cornerSize: CGSize(width: rect.height * 0.12, height: rect.height * 0.12))
        // Wheel
        path.addEllipse(in: CGRect(x: rect.minX + rect.width * 0.65, y: rect.midY + rect.height * 0.08, width: rect.width * 0.22, height: rect.width * 0.22))
        // Small back wheel
        path.addEllipse(in: CGRect(x: rect.minX + rect.width * 0.13, y: rect.midY + rect.height * 0.13, width: rect.width * 0.13, height: rect.width * 0.13))
        return path
    }
}

// Custom Elephant Shape
struct ElephantShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Head
        path.addArc(center: CGPoint(x: rect.midX - rect.width * 0.1, y: rect.midY - rect.height * 0.1), radius: rect.width * 0.22, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
        // Body
        path.addRoundedRect(in: CGRect(x: rect.minX + rect.width * 0.18, y: rect.midY - rect.height * 0.05, width: rect.width * 0.55, height: rect.height * 0.35), cornerSize: CGSize(width: rect.height * 0.18, height: rect.height * 0.18))
        // Trunk
        path.move(to: CGPoint(x: rect.midX - rect.width * 0.28, y: rect.midY + rect.height * 0.08))
        path.addQuadCurve(to: CGPoint(x: rect.midX - rect.width * 0.32, y: rect.midY + rect.height * 0.25), control: CGPoint(x: rect.midX - rect.width * 0.38, y: rect.midY + rect.height * 0.13))
        // Legs
        let legWidth = rect.width * 0.13
        let legHeight = rect.height * 0.22
        for i in 0..<3 {
            let x = rect.minX + rect.width * (0.22 + CGFloat(i) * 0.18)
            let y = rect.maxY - legHeight
            path.addRoundedRect(in: CGRect(x: x, y: y, width: legWidth, height: legHeight), cornerSize: CGSize(width: legWidth * 0.4, height: legWidth * 0.4))
        }
        // Tail
        path.move(to: CGPoint(x: rect.maxX - rect.width * 0.13, y: rect.midY + rect.height * 0.13))
        path.addQuadCurve(to: CGPoint(x: rect.maxX - rect.width * 0.05, y: rect.midY + rect.height * 0.22), control: CGPoint(x: rect.maxX, y: rect.midY + rect.height * 0.18))
        return path
    }
}

struct MinimalistPieceView: View {
    let piece: Piece
    let isRed: Bool
    
    var body: some View {
        ZStack {
            // Background circle (now white, 10% larger)
            Circle()
                .fill(Color.white)
                .frame(width: 44, height: 44)
            // Piece icon (now blue or red, 10% larger)
            pieceIcon
                .foregroundColor(isRed ? .red : .blue)
                .frame(width: 26.4, height: 26.4)
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
            ElephantShape()
        case .horse:
            Image(systemName: "hare.fill")
        case .chariot:
            Image(systemName: "car.2.fill")
        case .cannon:
            CannonShape()
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