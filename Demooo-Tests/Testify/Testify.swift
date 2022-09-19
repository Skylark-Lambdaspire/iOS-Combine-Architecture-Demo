
import Foundation
import Combine

// TODO: Sk - This is a bit stinky.
// Need to deal with the customError type-checking situation, as currently
// a completion is treated as a timeout failure.

class Testify {
    
    private static var dump: Set<AnyCancellable> = .init()
    
    private init() { }
    
    static func once<T: Publisher>(_ publisher: T) async throws {
        var done = false
        return try await withCheckedThrowingContinuation { t in
            publisher
                .timeout(1, scheduler: DispatchQueue.main)
                .sink { c in
                    if done { return }
                    done = true
                    switch c {
                    case .failure(let error):
                        t.resume(throwing: error)
                    default:
                        t.resume(throwing: TestifyError.timeout)
                    }
                } receiveValue: { _ in
                    if done { return }
                    done = true
                    t.resume()
                }
                .store(in: &dump)
        }
    }
}

enum TestifyError : Error {
    case timeout
}
