
import SwiftUI

struct StandardPreviewsEnvironment : ViewModifier {
    
    init(_ container: Container, _ configure: ((Container) -> Void) = { _ in }) {
        configure(container)
    }
        
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func standardPreviewsEnvironment() -> some View {
        modifier(StandardPreviewsEnvironment(PreviewContainer))
    }
}

fileprivate let PreviewContainer: Container = {
    
    let c: Container = .shared
    
    c.registerSingleton(AuthenticationService.self, {
        MockAuthenticationService(
            signIn: { .init(name: "Preview User")},
            signOut: { })
    })
    
    c.registerSingleton(TodosService.self, {
        MockTodosService(
            getTodos: { [] },
            saveTodos: { _ in })
    })
    
    c.registerSingleton(AuthenticationContext.self, AuthenticationContext.init)
    c.registerSingleton(TodosContext.self, TodosContext.init)
    c.registerSingleton(ErrorContext.self, ErrorContext.init)
    
    return c
}()
