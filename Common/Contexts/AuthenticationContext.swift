
import Foundation

class AuthenticationContext : ObservableObject {
    
    @Published private(set) var state: AuthenticationState = .notAuthenticated
    
    @Resolved private var authenticationService: AuthenticationService
    
    func signIn() {
        Task {
            do {
                state = .authenticated(try await authenticationService.signIn())
            } catch {
                state = .babow(.badTimes)
            }
        }
    }
    
    func signOut() {
        Task {
            await authenticationService.signOut()
            state = .notAuthenticated
        }
    }
}

enum AuthenticationState : Equatable {
    case notAuthenticated
    case authenticated(AuthenticatedUser)
    case babow(AuthenticationError)
}

enum AuthenticationError : Error, Equatable {
    case badTimes
}
