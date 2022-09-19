
struct IoC {
    
    private init() { }
    
    static func configure() -> Container {
            
        let c: Container = .shared
        
        c.registerSingleton(AuthenticationService.self, RealAuthenticationService.init)
        c.registerSingleton(TodosService.self, RealTodosService.init)
            
        c.registerSingleton(AuthenticationContext.self, AuthenticationContext.init)
        c.registerSingleton(TodosContext.self, TodosContext.init)
        c.registerSingleton(ErrorContext.self, ErrorContext.init)
        
        return c
    }
}
