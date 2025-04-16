//
//  ContentView.swift
//  Automatic DI
//
//  Created by Israel Manzo on 4/16/25.
//

import SwiftUI

/**
 `Dependency Injection (DI)`
 Dependency injection (DI) is the most popular design pattern in term of object-oriented programming (OOP). It is a technique, that manage how an object is created, when another object depends on it. `The concept of dependency injection itself is pretty simple, there is an object depends on one or more dependencies, then the dependencies are injected into the dependent object, instead of created it inside the object.`
 */
/**
 `Automatic Dependency Injection (DI)`
 Automatic Dependency Injection (DI), basically dependency injection, but the injection process is automated. With Automatic DI developer don’t have to manually inject the dependencies, and stop worrying about where and how to inject the dependencies.
 */

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
