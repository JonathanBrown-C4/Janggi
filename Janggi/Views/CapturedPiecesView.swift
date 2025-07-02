import SwiftUI

struct CapturedPiecesView: View {
    let pieces: [Piece]
    let color: Color
    @ObservedObject var settings: Settings = Settings()

    var body: some View {
        VStack {
            Text("Captured")
                .font(.headline)
                .foregroundColor(color)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 5) {
                    ForEach(pieces, id: \.imageName) { piece in
                        PieceView(piece: piece, settings: settings, isInCheck: false, isSelected: false, isCapturable: false)
                            .frame(width: 44, height: 44)
                    }
                }
            }
            .frame(width: 110, height: 220)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

#Preview {
    CapturedPiecesView(pieces: [], color: .red)
} 
