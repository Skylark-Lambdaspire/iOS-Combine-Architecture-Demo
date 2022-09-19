import Foundation

class SignInScreenViewModel : ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published private(set) var authenticatedUser: AuthenticatedUser?
    
    @Resolved private var authenticationContext: AuthenticationContext
    
    var isAuthenticated: Bool { authenticatedUser != nil }
    
    init() {
        maintainAuthenticatedUser()
    }
    
    func signIn() {
        authenticationContext.signIn()
    }
    
    func signOut() {
        authenticationContext.signOut()
    }
    
    private func maintainAuthenticatedUser() {
        authenticationContext
            .$state
            .map { s in
                switch s {
                case .authenticated(let user):
                    return user
                default:
                    return nil
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$authenticatedUser)
    }
}
