import SwiftUI

class Chariot: Piece {
    override var movementRules: [MovementRule] {
        return [
            MovementRule(direction: .orthogonal, maxDistance: 0, requiresPlatform: false, palaceRestricted: false, blockingRules: .stopAtFirst)
        ]
    }
    
    // Initializer for left chariot (starts at col 0)
    init(isRed: Bool, isLeft: Bool) {
        let imageName = isRed ? "red_chariot" : "blue_chariot"
        let startingPosition: Position
        if isRed {
            startingPosition = isLeft ? Position(row: 0, col: 0) : Position(row: 0, col: 8)
        } else {
            startingPosition = isLeft ? Position(row: 9, col: 0) : Position(row: 9, col: 8)
        }
        super.init(imageName: imageName, isRed: isRed, position: startingPosition, size: .medium)
    }
    
    // Secondary initializer for custom positions (for testing or special scenarios)
    init(isRed: Bool, position: Position) {
        let imageName = isRed ? "red_chariot" : "blue_chariot"
        super.init(imageName: imageName, isRed: isRed, position: position, size: .medium)
    }
} 
