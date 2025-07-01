import Foundation
import SwiftUI

class Settings: ObservableObject {
    @Published var showMoveHints: Bool {
        didSet {
            UserDefaults.standard.set(showMoveHints, forKey: "showMoveHints")
        }
    }
    
    @Published var useTraditionalPieces: Bool {
        didSet {
            UserDefaults.standard.set(useTraditionalPieces, forKey: "useTraditionalPieces")
        }
    }
    
    init() {
        self.showMoveHints = UserDefaults.standard.bool(forKey: "showMoveHints")
        self.useTraditionalPieces = UserDefaults.standard.bool(forKey: "useTraditionalPieces")
        
        // Set defaults if not previously set
        if UserDefaults.standard.object(forKey: "showMoveHints") == nil {
            self.showMoveHints = true
        }
        if UserDefaults.standard.object(forKey: "useTraditionalPieces") == nil {
            self.useTraditionalPieces = true
        }
    }
} 