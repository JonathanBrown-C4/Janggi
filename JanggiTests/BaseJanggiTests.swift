import XCTest
@testable import Janggi

class BaseJanggiTests: XCTestCase {
    var board: Board!
    
    override func setUp() {
        super.setUp()
        board = Board()
        board.setupBoard()
    }
    
    override func tearDown() {
        board = nil
        super.tearDown()
    }
} 