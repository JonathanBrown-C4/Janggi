import SwiftUI

enum PieceSize {
    case small
    case medium
    case large

    var size: CGFloat {
        switch self {
        case .small: return 30
        case .medium: return 40
        case .large: return 60
        }
    }
}

struct PieceView: View {
    let piece: Piece
    let isInCheck: Bool
    let isSelected: Bool

    var body: some View {
        Image(piece.imageName)
            .resizable()
            .scaledToFit()
            .padding(6)
            .frame(width: piece.size.size, height: piece.size.size)
            .background(Hexagon().fill(backgroundColor))
            .clipShape(Hexagon())
            .overlay(
                Hexagon()
                    .stroke(Color(.darkGray), lineWidth: 2)
            )
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return Color.blue.opacity(0.3)
        } else if isInCheck {
            return Color.red.opacity(0.3)
        } else {
            return Color.white
        }
    }
}

struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let points = (0..<6).map { i in
            let angle = Double(i) * .pi / 3
            return CGPoint(
                x: center.x + radius * CGFloat(cos(angle)),
                y: center.y + radius * CGFloat(sin(angle))
            )
        }
        path.move(to: points[0])
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()
        return path
    }
}

#Preview {
    VStack {
        PieceView(piece: General(isRed: true, position: Position(row: 0, col: 4)), isInCheck: false, isSelected: false)
        PieceView(piece: Horse(isRed: false, position: Position(row: 9, col: 1)), isInCheck: false, isSelected: true)
        PieceView(piece: Soldier(isRed: true, position: Position(row: 3, col: 0)), isInCheck: false, isSelected: false)
        PieceView(piece: General(isRed: false, position: Position(row: 8, col: 4)), isInCheck: true, isSelected: false)
    }
} 
