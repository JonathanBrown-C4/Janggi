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

    var body: some View {
        Image(piece.imageName)
            .resizable()
            .scaledToFit()
            .frame(width: piece.size.size, height: piece.size.size)
            .clipShape(Hexagon())
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
        PieceView(piece: General(isRed: true, position: Position(row: 0, col: 4)))
        PieceView(piece: Horse(isRed: false, position: Position(row: 9, col: 1)))
        PieceView(piece: Pawn(isRed: true, position: Position(row: 3, col: 0)))
    }
} 