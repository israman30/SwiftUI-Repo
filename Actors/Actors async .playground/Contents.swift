import UIKit

/**
 `What Are Actors?
 `In Swift, actors are a reference type, similar to classes, but they come with built-in thread safety. When you use an actor to manage shared state, Swift automatically ensures that only one piece of code at a time can modify that state. This is done by isolating data within the actor, preventing race conditions and other concurrency issues.
 
 `Actors are especially helpful in multi-threaded applications where shared mutable data might be accessed simultaneously by different tasks.
 */
