import UIKit

/**
 In the earlier parts of this series, we explored `Publishers`, `Subscribers`, and how data flows in Combine. Now, it’s time to dive into one of the most powerful aspects of Combine: Operators.

 Operators are the transformers in Combine’s pipeline. They allow you to modify, filter, combine, and handle data as it travels from `Publisher → Operator(s) → Subscriber`.
 
 `What are Operators in Combine?
 Operators are methods you apply to a Publisher to transform or react to the emitted values.

 Think of them like the functions in a data pipeline:

 A `map` operator can transform values.
 A `filter` operator can drop unwanted values.
 A `debounce` operator can control the frequency of events.
 
 `Categories of Operators
 Operators in Combine can be broadly divided into:

 `Transforming Operators` → Change the output values.
 `map`, `compactMap`, `replaceNil`, `scan`, `flatMap`.
 `Filtering Operators `→ Control which values are allowed to pass.
 `filter`, `removeDuplicates`, `dropFirst`, `prefix`.
 `Combining Operators` → Merge or zip multiple publishers.
 `merge`, `combineLatest`, `zip`, `switchToLatest`.
 `Time-Based Operators` → Handle delays and throttling.
 `delay`, `debounce`, `throttle`, `timeout`.
 `Error-Handling Operators` → Handle failures gracefully.
 `catch`, `retry`, `replaceError`.
 */
