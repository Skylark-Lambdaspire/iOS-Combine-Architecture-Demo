
struct IoC {
    
    private init() { }
    
    static func configure(
        authenticationService: MockAuthenticationService = .init(),
        todosService: MockTodosService = .init()) {
            
            Container.shared.registerSingleton(AuthenticationService.self, { authenticationService })
            Container.shared.registerSingleton(TodosService.self, { todosService })
            
            Container.shared.registerSingleton(AuthenticationContext.self, AuthenticationContext.init)
            Container.shared.registerSingleton(TodosContext.self, TodosContext.init)
            Container.shared.registerSingleton(ErrorContext.self, ErrorContext.init)
        }
}
