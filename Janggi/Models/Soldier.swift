import Foundation

class Soldier: Piece {
    init(isRed: Bool, column: Int) {
        let row = isRed ? 3 : 6
        let imageName = isRed ? "red_soldier" : "blue_soldier"
        super.init(imageName: imageName, isRed: isRed, position: Position(row: row, col: column), size: .small)
    }
    
    init(isRed: Bool, position: Position) {
        let imageName = isRed ? "red_soldier" : "blue_soldier"
        super.init(imageName: imageName, isRed: isRed, position: position, size: .small)
    }
    
    override var movementRules: [MovementRule] {
        var rules: [MovementRule] = []
        
        // Always have orthogonal movement
        rules.append(MovementRule(direction: .orthogonal, maxDistance: 1, requiresPlatform: false, palaceRestricted: false, blockingRules: .stopAtFirst))
        
        // Add diagonal movement when in palace
        if isInPalace() {
            rules.append(MovementRule(direction: .diagonal, maxDistance: 1, requiresPlatform: false, palaceRestricted: true, blockingRules: .stopAtFirst))
        }
        
        return rules
    }
    
    // Helper method to check if soldier is in the palace
    private func isInPalace() -> Bool {
        let palaceRows = isRed ? [0, 1, 2] : [7, 8, 9]
        let palaceCols = [3, 4, 5]
        
        return palaceRows.contains(currentPosition.row) && palaceCols.contains(currentPosition.col)
    }
} 