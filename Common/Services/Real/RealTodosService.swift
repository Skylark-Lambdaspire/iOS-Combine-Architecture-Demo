import Darwin
import Foundation

class RealTodosService : TodosService {
    
    // Pretend this is The Cloud.
    private var todos: [Todo] = [
        .init(id: .init(), name: "Do the dishes", done: false),
        .init(id: .init(), name: "Do the laundry", done: false),
        .init(id: .init(), name: "Contemplate sense of self", done: false),
        .init(id: .init(), name: "Procrastinate a lot", done: true),
        .init(id: .init(), name: "Cry a lot", done: true)
    ]
    
    // This only happens with stateful services.
    // You can probably argue that stateful services should be Contexts.
    lazy var getTodos: () async throws -> [Todo] = {
        try await Task.sleep(nanoseconds: 1000000000)
        return self.todos
    }
    
    lazy var saveTodos: ([Todo]) async throws -> Void = { new in
        try await Task.sleep(nanoseconds: 1000000000)
        if [true, false].randomElement()! {
            throw TodosError.badTimes
        }
        self.todos = new
    }
}

enum TodosError : Error {
    case badTimes
}

extension TodosError : LocalizedError {
    var errorDescription: String? {
        "You got unlucky!"
    }
}
