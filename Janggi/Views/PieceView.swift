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
    @ObservedObject var settings: Settings
    let isInCheck: Bool
    let isSelected: Bool
    let isCapturable: Bool

    var body: some View {
        Group {
            if settings.useTraditionalPieces {
                // Traditional piece images
                Image(piece.imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(6)
                    .frame(width: piece.size.size, height: piece.size.size)
                    .background(Hexagon().fill(backgroundColor))
                    .clipShape(Hexagon())
                    .overlay(
                        Hexagon()
                            .stroke(outlineColor, lineWidth: outlineWidth)
                    )
                    .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 0)
            } else {
                // Minimalist icon pieces
                MinimalistPieceView(piece: piece, isRed: piece.isRed)
                    .frame(width: piece.size.size, height: piece.size.size)
                    .background(Hexagon().fill(backgroundColor))
                    .clipShape(Hexagon())
                    .overlay(
                        Hexagon()
                            .stroke(outlineColor, lineWidth: outlineWidth)
                    )
                    .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 0)
            }
        }
    }
    
    private var backgroundColor: Color {
        if isInCheck {
            return Color.red.opacity(0.3)
        } else {
            return Color.white
        }
    }
    
    private var outlineColor: Color {
        if isSelected {
            return Color.blue
        } else if isCapturable {
            return Color.green
        } else {
            return Color(.darkGray)
        }
    }
    
    private var outlineWidth: CGFloat {
        if isSelected || isCapturable {
            return 3
        } else {
            return 2
        }
    }
    
    private var shadowColor: Color {
        if isSelected {
            return Color.blue.opacity(0.6)
        } else if isCapturable {
            return Color.green.opacity(0.6)
        } else {
            return Color.clear
        }
    }
    
    private var shadowRadius: CGFloat {
        if isSelected || isCapturable {
            return 8
        } else {
            return 0
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
        PieceView(piece: General(isRed: true, position: Position(row: 0, col: 4)), settings: Settings(), isInCheck: false, isSelected: false, isCapturable: false)
        PieceView(piece: Horse(isRed: false, position: Position(row: 9, col: 1)), settings: Settings(), isInCheck: false, isSelected: true, isCapturable: false)
        PieceView(piece: Soldier(isRed: true, position: Position(row: 3, col: 0)), settings: Settings(), isInCheck: false, isSelected: false, isCapturable: true)
        PieceView(piece: General(isRed: false, position: Position(row: 8, col: 4)), settings: Settings(), isInCheck: true, isSelected: false, isCapturable: false)
    }
} 
