
import XCTest

fileprivate let testUser: AuthenticatedUser = .init(name: "Test User")

class TodosScreenViewModelTests : XCTestCase {
    
    private lazy var authenticationContext: AuthenticationContext = { Container.shared.resolve() }()
    
    override func setUp() {
        IoC.configure(
            authenticationService: .init(
                signIn: { testUser },
                signOut: { }),
            todosService: .init(
                getTodos: <#T##() async throws -> [Todo]#>,
                saveTodos: <#T##([Todo]) async throws -> Void#>))
    }
    
    func testSignIn() async throws {
        
        XCTAssertTrue(authenticationContext.state == .notAuthenticated)
        
        authenticationContext.signIn()
        
        try await Testify.once(authenticationContext.$state.first { $0 == .authenticated(testUser) })
    }
    
    func testSignOut() async throws {
        
        authenticationContext.signIn()
        
        try await Testify.once(authenticationContext.$state.first { $0 == .authenticated(testUser) })
        
        authenticationContext.signOut()
        
        try await Testify.once(authenticationContext.$state.first { $0 == .notAuthenticated })
    }

}
