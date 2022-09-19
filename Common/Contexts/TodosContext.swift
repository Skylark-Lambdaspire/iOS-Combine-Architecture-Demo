
import Combine
import Foundation

class TodosContext : ObservableObject {
    
    @Published private(set) var todos: [Todo] = []
    
    @Published private(set) var error: Error? = nil
    
    @Resolved private var todosService: TodosService
    
    @Resolved private var authenticationContext: AuthenticationContext
    @Resolved private var errorContext: ErrorContext
    
    private var subs: Set<AnyCancellable> = .init()
    
    init() {
        loadTodosWhenUserAuthenticates()
        saveTodosWhenTheyChange()
        clearTodosWhenUserUnauthenticates()
    }
    
    func refreshAwaitable() async {
        todos = (try? await todosService.getTodos()) ?? []
    }
    
    func toggle(_ todo: Todo) {
        
        var todo = todo
        todo.done = !todo.done
        
        todos = todos.map { $0.id == todo.id ? todo : $0 }
    }
    
    func delete(todo: Todo) {
        todos = todos.filter { $0.id != todo.id }
    }
    
    func add(_ name: String) {
        todos.append(.init(id: .init(), name: name, done: false))
    }
    
    private func loadTodosWhenUserAuthenticates() {
        authenticationContext
            .$state
            .compactMap {
                switch $0 {
                case .authenticated(let user):
                    return user
                default:
                    return nil
                }
            }
            // For some reason, dumbass Swift compiler can't
            // figure this out without the signature specified.
            .asyncMap { [todosService] (user: AuthenticatedUser) in
                try await todosService.getTodos()
            }
            .replaceError(with: [])
            .assign(to: &$todos)
    }
    
    private func saveTodosWhenTheyChange() {
        $todos
            .dropFirst()
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [todosService, errorContext] todos in
                Task {
                    do {
                        try await todosService.saveTodos(todos)
                    } catch {
                        errorContext.push(errorMessage: error.localizedDescription)
                    }
                }
            }
            .store(in: &subs)
    }
    
    private func clearTodosWhenUserUnauthenticates() {
        authenticationContext
            .$state
            .dropFirst()
            .filter {
                switch $0 {
                case .notAuthenticated, .babow(_): return true
                default: return false
                }
            }
            .map { _ in [] }
            .assign(to: &$todos)
    }
}
