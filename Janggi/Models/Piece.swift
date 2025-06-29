import SwiftUI
import Foundation

// Direction enum for piece movement
enum Direction {
    case orthogonal // up, down, left, right
    case diagonal   // up-left, up-right, down-left, down-right
    case lShape     // horse moves
    case custom     // cannon, elephant
}

enum BlockingRule {
    case none // can move through pieces
    case stopAtFirst // stops at first piece (chariot)
    case jumpOver // needs platform, jumps over (cannon)
    case centerBlock // blocked by center position (elephant/horse)
}

struct MovementRule {
    let direction: Direction
    let maxDistance: Int // 0 = unlimited
    let requiresPlatform: Bool // for cannon
    let palaceRestricted: Bool // for guard/general
    let blockingRules: BlockingRule
    
    init(direction: Direction, maxDistance: Int = 1, requiresPlatform: Bool = false, palaceRestricted: Bool = false, blockingRules: BlockingRule = .stopAtFirst) {
        self.direction = direction
        self.maxDistance = maxDistance
        self.requiresPlatform = requiresPlatform
        self.palaceRestricted = palaceRestricted
        self.blockingRules = blockingRules
    }
}

// Position struct to represent board coordinates
struct Position: Hashable, Equatable {
    let row: Int
    let col: Int
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
}

// Piece type enum
enum PieceType {
    case general
    case guard_
    case elephant
    case horse
    case chariot
    case cannon
    case soldier
    
    var description: String {
        switch self {
        case .general: return "general"
        case .guard_: return "guard"
        case .elephant: return "elephant"
        case .horse: return "horse"
        case .chariot: return "chariot"
        case .cannon: return "cannon"
        case .soldier: return "soldier"
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
    var movementRules: [MovementRule] { get }
    func isWithinBounds(_ position: Position) -> Bool
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
        case is Soldier: return .soldier
        default: fatalError("Unknown piece type")
        }
    }
    var currentPosition: Position
    var size: PieceSize
    var movementRules: [MovementRule] {
        return []
    }
    
    init(imageName: String, isRed: Bool, position: Position, size: PieceSize) {
        self.imageName = imageName
        self.isRed = isRed
        self.currentPosition = position
        self.size = size
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