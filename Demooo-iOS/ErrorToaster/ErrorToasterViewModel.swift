
import Foundation
import Combine

class ErrorToasterViewModel : ObservableObject {
    
    @Published private(set) var errorMessages: [String] = []
    
    @Resolved private var errorContext: ErrorContext
    
    init() {
        maintainErrorMessages()
    }
    
    private func maintainErrorMessages() {
        errorContext
            .$errorMessages
            .receive(on: DispatchQueue.main)
            .assign(to: &$errorMessages)
    }
}
