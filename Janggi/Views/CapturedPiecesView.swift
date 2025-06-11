import SwiftUI

struct CapturedPiecesView: View {
    let pieces: [Piece]
    let color: Color

    var body: some View {
        VStack {
            Text("Captured")
                .font(.headline)
                .foregroundColor(color)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 30))], spacing: 5) {
                    ForEach(pieces, id: \.imageName) { piece in
                        Image(piece.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                }
            }
            .frame(width: 100, height: 200)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
} 