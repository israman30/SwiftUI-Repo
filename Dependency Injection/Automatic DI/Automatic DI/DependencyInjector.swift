//
//  DependencyInjector.swift
//  Automatic DI
//
//  Created by Israel Manzo on 4/16/25.
//

import Foundation

/**
 `1. Create the helper class a.k.a the injector.`
 Let’s start with the injector (helper class), because without this we can’t do the automatic dependency injection. This is very similar with my implementation on previous article, just with conformances to Swift 6.

 `@Inject `is used to inject the dependency.
 `@Provider` is used to provide the dependency.
 */

@MainActor
struct DependencyInjector {
    private var dependencies: [String: Any] = [:]
    static var shader = DependencyInjector()
    
    private init() {}
    
    func resolve<T>() -> T {
        guard let t = dependencies[String(describing: T.self)] as? T else {
            fatalError("No porvider registered for \(T.self)")
        }
        return t
    }
    
    mutating func register<T>(_ provider: T) {
        dependencies[String(describing: T.self)] = provider
    }
}

@MainActor
@propertyWrapper struct Inject<T> {
    var wrappedValue: T
    
    init() {
        self.wrappedValue = DependencyInjector.shader.resolve()
    }
}

@MainActor
@propertyWrapper struct Provider<T> {
    var wrappedValue: T
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        DependencyInjector.shader.register(wrappedValue)
    }
}
