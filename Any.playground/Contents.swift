import UIKit

// MARK: - What is Any?
// In Swift, Any is a type that can represent any kind of value, whether it be an integer, string, object, or even a function. It's a way to be flexible when you don't know exactly what type of data you'll be dealing with.
// Think of Any as a versatile box that can hold anything. Imagine you have a magical box at home. One day it might contain your keys, another day it could have a book, and the next day it might hold a bottle of water. This box doesn’t care what you put inside, it just holds it. Similarly, Any can hold any type of value in Swift.

var myVariable: Any

myVariable = 42
print(myVariable) // prints 42

myVariable = "Hello, world!"
print(myVariable) // prints "Hello, world!"

myVariable = [1, 2, 3, 4, 5]
print(myVariable) // prints [1, 2, 3, 4, 5]

// MARK: -  Special Cases: Handling Any
// When you use Any, you'll often need to cast it back to its original type to work with it. Here's how you can do it safely:
var myVariable1: Any = "Hello, Swift!"

if let myString = myVariable1 as? String {
    print(myString) // prints "Hello, Swift!"
} else {
    print("The variable is not a String")
}

// MARK: - Another Special Case: Collections of Any
// Sometimes, you might need to store different types of values in a collection, such as an array:
let mixedArray: [Any] = [1, "two", 3.0, [4, 5, 6]]

for item in mixedArray {
    if let intItem = item as? Int {
        print("Integer: \(intItem)")
    } else if let stringItem = item as? String {
        print("String: \(stringItem)")
    } else if let doubleItem = item as? Double {
        print("Double: \(doubleItem)")
    } else if let arrayItem = item as? [Int] {
        print("Array of Int: \(arrayItem)")
    }
}

// MARK: - Encoding and Decoding Any
// When working with Any, encoding and decoding can be tricky because you need to handle different types. Here's an example:
struct AnyCodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    enum CodingKeys: String, CodingKey {
        case value
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let intValue = value as? Int {
            try container.encode(intValue, forKey: .value)
        } else if let stringValue = value as? String {
            try container.encode(stringValue, forKey: .value)
        } else if let doubleValue = value as? Double {
            try container.encode(doubleValue, forKey: .value)
        } else if let boolValue = value as? Bool {
            try container.encode(boolValue, forKey: .value)
        } else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Invalid type"))
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let intValue = try? container.decode(Int.self, forKey: .value) {
            value = intValue
        } else if let stringValue = try? container.decode(String.self, forKey: .value) {
            value = stringValue
        } else if let doubleValue = try? container.decode(Double.self, forKey: .value) {
            value = doubleValue
        } else if let boolValue = try? container.decode(Bool.self, forKey: .value) {
            value = boolValue
        } else {
            throw DecodingError.dataCorruptedError(forKey: .value, in: container, debugDescription: "Invalid type")
        }
    }
}

let original: [String: Any] = ["name": "John", "age": 30, "height": 5.9]

do {
    let jsonData = try JSONEncoder().encode(original.mapValues { AnyCodable($0) })
    print(String(data: jsonData, encoding: .utf8)!) // prints JSON representation
    
    let decoded = try JSONDecoder().decode([String: AnyCodable].self, from: jsonData)
    print(decoded.mapValues { $0.value }) // prints original dictionary
} catch {
    print("Failed to encode or decode: \(error)")
}
