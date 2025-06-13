import SwiftUI

struct PalaceView: View {
    let size: CGFloat // The width/height of the palace square (covers 2 cells)

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            Path { path in
                // X shape: (0,0) to (2,2)
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: w, y: h))
                // X shape: (0,2) to (2,0)
                path.move(to: CGPoint(x: w, y: 0))
                path.addLine(to: CGPoint(x: 0, y: h))
            }
            .stroke(Color.black, lineWidth: 2)
        }
    }
}

#Preview {
    ZStack {
        Rectangle()
            .fill(Color(red: 0.8, green: 0.7, blue: 0.5))
            .frame(width: 120, height: 120)
        PalaceView(size: 80)
            .frame(width: 80, height: 80)
    }
    .padding()
} 