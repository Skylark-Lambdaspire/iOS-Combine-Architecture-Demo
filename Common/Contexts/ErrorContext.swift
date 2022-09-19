
import Combine
import Foundation

class ErrorContext : ObservableObject {
    
    @Published private(set) var errorMessages: [String] = []
    
    private var subs: Set<AnyCancellable> = .init()
    
    init() {
        eliminateErrorMessagesAfterAShortDelay()
    }
    
    func push(errorMessage: String) {
        errorMessages.append(errorMessage)
    }
    
    private func eliminateErrorMessagesAfterAShortDelay() {
        $errorMessages
            .filter { !$0.isEmpty }
            .debounce(for: 3, scheduler: DispatchQueue.main)
            .sink { _ in
                _ = self.errorMessages.popLast()
            }
            .store(in: &subs)
    }
}
