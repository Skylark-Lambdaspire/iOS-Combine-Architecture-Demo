
import Foundation

protocol DependencyRegistry {
    func registerSingleton<T>(_ t: T.Type, _ f: @escaping () -> T)
    func register<T>(_ t: T.Type, _ f: @escaping () -> T)
    
    func unregister<T>(_ t: T.Type)
}

protocol DependencyResolver {
    func resolve<T>() -> T
}

class Container : DependencyRegistry, DependencyResolver {
    
    static let shared: Container = .init()
    
    private var registrations: [String : () -> Any] = [:]
    
    func registerSingleton<T>(_ t: T.Type, _ f: @escaping () -> T) {
        var value: T!
        register(t, {
            if value == nil {
                value = f()
            }
            return value
        })
    }
    
    func register<T>(_ t: T.Type, _ f: @escaping () -> T) {
        registrations[key(for: t)] = f
    }
    
    func unregister<T>(_ t: T.Type) {
        registrations.removeValue(forKey: key(for: t))
    }
    
    func resolve<T>() -> T {
        guard let resolved = registrations[key(for: T.self)]?() as? T else {
            fatalError("Dependency resolution error for type \(T.self) from \(registrations.keys.joined(separator: ", "))")
        }
        return resolved
    }
    
    private func key(for type: Any.Type) -> String {
        .init(describing: type)
    }
}

@propertyWrapper struct Resolved<T> {

    let wrappedValue: T
    
    init(_ d: DependencyResolver = Container.shared) {
        wrappedValue = d.resolve()
    }
}
