
class RealAuthenticationService : AuthenticationService {
    
    let signIn: () async throws -> AuthenticatedUser = {
        try await Task.sleep(nanoseconds: 2000000000)
        return .init(name: "Very Real User")
    }
    
    let signOut: () async -> Void = {
        try? await Task.sleep(nanoseconds: 2000000000)
    }
}
