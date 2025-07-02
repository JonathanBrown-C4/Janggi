import SwiftUI

class MessageManager: ObservableObject {
    @Published var message: String = ""
    @Published var show: Bool = false
    private var dismissTask: DispatchWorkItem?
    
    func showMessage(_ text: String, duration: Double = 2.5) {
        dismissTask?.cancel()
        message = text
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            show = true
        }
        let task = DispatchWorkItem { [weak self] in
            withAnimation(.easeInOut(duration: 0.4)) {
                self?.show = false
            }
        }
        dismissTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
    }
} 