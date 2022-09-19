
import Foundation
import Combine

class TodosScreenViewModel : ObservableObject {
    
    @Published private(set) var todos: [Todo] = []
    
    @Resolved private var todosContext: TodosContext
    
    init() {
        maintainTodos()
    }
    
    @Sendable func refresh() async {
        await todosContext.refreshAwaitable()
    }
    
    func toggle(_ todo: Todo) {
        todosContext.toggle(todo)
    }
    
    func add(_ name: String) {
        todosContext.add(name)
    }
    
    private func maintainTodos() {
        todosContext
            .$todos
            .receive(on: DispatchQueue.main)
            .assign(to: &$todos)
    }
}
