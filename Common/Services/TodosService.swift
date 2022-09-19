
import Foundation

struct Todo {
    var id: UUID
    var name: String
    var done: Bool
}

protocol TodosService {
    var getTodos: () async throws -> [Todo] { get }
    var saveTodos: ([Todo]) async throws -> Void { get }
}
