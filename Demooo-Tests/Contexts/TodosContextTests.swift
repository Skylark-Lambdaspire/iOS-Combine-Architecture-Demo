
import XCTest

fileprivate let testUser: AuthenticatedUser = .init(name: "Test User")

class TodosContextTests: XCTestCase {
    
    lazy private var authenticationContext: AuthenticationContext = { Container.shared.resolve() }()
    lazy private var todosContext: TodosContext = { Container.shared.resolve() }()
    
    override func setUp() {
        IoC.configure(
            
            authenticationService: .init(
                signIn: { testUser },
                signOut: { }),
            
            todosService: .init(
                getTodos: {
                    [
                        .init(id: .init(), name: "Test 1", done: true),
                        .init(id: .init(), name: "Test 2", done: false),
                        .init(id: .init(), name: "Test 3", done: false)
                    ]
                },
                saveTodos: { _ in }))
    }
    
    func testFetchesTodosWhenUserSignsIn() async throws {
        
        XCTAssert(todosContext.todos.isEmpty)
        
        authenticationContext.signIn()
        
        try await Testify.once(todosContext.$todos.filter { $0.count == 3 })
    }
    
    func testClearsTodosWhenUserSignsOut() async throws {
        
        authenticationContext.signIn()
        
        try await Testify.once(todosContext.$todos.filter { !$0.isEmpty })
        
        authenticationContext.signOut()
        
        try await Testify.once(todosContext.$todos.filter { $0.isEmpty })
    }
}
