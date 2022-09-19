
struct AuthenticatedUser : Equatable {
    var name: String
}

protocol AuthenticationService {
    var signIn: () async throws -> AuthenticatedUser { get }
    var signOut: () async -> Void { get }
}
