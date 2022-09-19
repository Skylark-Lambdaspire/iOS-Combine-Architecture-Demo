
struct MockTodosService : TodosService {
    var getTodos: () async throws -> [Todo] = { fatalError() }
    var saveTodos: ([Todo]) async throws -> Void = { _ in fatalError() }
}
