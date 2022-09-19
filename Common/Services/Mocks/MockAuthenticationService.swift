
struct MockAuthenticationService : AuthenticationService {
    var signIn: () async throws -> AuthenticatedUser = { fatalError() }
    var signOut: () async -> Void = { fatalError() }
}
