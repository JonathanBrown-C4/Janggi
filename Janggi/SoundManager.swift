import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var moveSound: AVAudioPlayer?
    private var captureSound: AVAudioPlayer?
    private var checkSound: AVAudioPlayer?
    private var winSound: AVAudioPlayer?
    
    private init() {
        setupSounds()
    }
    
    private func setupSounds() {
        // Load sound files
        if let moveURL = Bundle.main.url(forResource: "move", withExtension: "wav") {
            moveSound = try? AVAudioPlayer(contentsOf: moveURL)
        }
        
        if let captureURL = Bundle.main.url(forResource: "capture", withExtension: "wav") {
            captureSound = try? AVAudioPlayer(contentsOf: captureURL)
        }
        
        if let checkURL = Bundle.main.url(forResource: "check", withExtension: "wav") {
            checkSound = try? AVAudioPlayer(contentsOf: checkURL)
        }
        
        if let winURL = Bundle.main.url(forResource: "win", withExtension: "wav") {
            winSound = try? AVAudioPlayer(contentsOf: winURL)
        }
    }
    
    func playMoveSound() {
        moveSound?.play()
    }
    
    func playCaptureSound() {
        captureSound?.play()
    }
    
    func playCheckSound() {
        checkSound?.play()
    }
    
    func playWinSound() {
        winSound?.play()
    }
} 