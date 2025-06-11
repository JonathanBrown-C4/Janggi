import SwiftUI
import Foundation

// Direction enum for piece movement
enum Direction {
    case up, down, left, right
    case upLeft, upRight, downLeft, downRight
}

// Position struct to represent board coordinates
struct Position: Equatable {
    let row: Int
    let col: Int
}

// Piece type enum
enum PieceType {
    case general
    case guard_
    case elephant
    case horse
    case chariot
    case cannon
    case pawn
    
    var description: String {
        switch self {
        case .general: return "general"
        case .guard_: return "guard"
        case .elephant: return "elephant"
        case .horse: return "horse"
        case .chariot: return "chariot"
        case .cannon: return "cannon"
        case .pawn: return "pawn"
        }
    }
}

// Protocol that all pieces must conform to
protocol PieceProtocol {
    var imageName: String { get }
    var isRed: Bool { get }
    var color: PieceColor { get }
    var type: PieceType { get }
    var currentPosition: Position { get set }
    var size: PieceSize { get }
    
    // Returns all valid moves for the piece from its current position
    func validMoves(board: Board) -> [Position]
    
    // Returns true if the move is valid
    func canMove(to position: Position, board: Board) -> Bool
}

// Base class for all pieces
class Piece: PieceProtocol {
    let imageName: String
    let isRed: Bool
    var color: PieceColor {
        isRed ? .red : .blue
    }
    var type: PieceType {
        switch self {
        case is General: return .general
        case is Guard: return .guard_
        case is Elephant: return .elephant
        case is Horse: return .horse
        case is Chariot: return .chariot
        case is Cannon: return .cannon
        case is Pawn: return .pawn
        default: fatalError("Unknown piece type")
        }
    }
    var currentPosition: Position
    var size: PieceSize
    
    init(imageName: String, isRed: Bool, position: Position, size: PieceSize) {
        self.imageName = imageName
        self.isRed = isRed
        self.currentPosition = position
        self.size = size
    }
    
    func validMoves(board: Board) -> [Position] {
        return []
    }
    
    func canMove(to position: Position, board: Board) -> Bool {
        return validMoves(board: board).contains(position)
    }
    
    // Helper method to check if a position is within board bounds
    func isWithinBounds(_ position: Position) -> Bool {
        return position.row >= 0 && position.row < 10 && position.col >= 0 && position.col < 9
    }
    
    // Helper method to check if a position is occupied by a piece of the same color
    func isOccupiedBySameColor(_ position: Position, board: Board) -> Bool {
        if let piece = board.pieceAt(position) {
            return piece.isRed == self.isRed
        }
        return false
    }
}

// Remove redundant class definitions for each piece type 