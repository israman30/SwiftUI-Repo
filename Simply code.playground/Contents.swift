import UIKit

// MARK: - Map
/// - Using Map to Transform Values in an Array

/// Before
let numbers = [1, 2, 3, 4, 5]
var doubleNumbers = [Int]()

for number in numbers {
    doubleNumbers.append(number * 2)
}

/// After
let doubleNumberMap = numbers.map { $0 * 2 }

// MARK: - Filter
/// Using Higher-Order Functions to Filter Data

/// Before
var evenNumbers: [Int] = []
for number in numbers {
    if number % 2 == 0 {
        evenNumbers.append(number)
    }
}

/// After
let evenNumbersFilter = numbers.filter { $0 % 2 == 0 }

// MARK: - Tupples
/// Using shorthand to Declare Tuples
/// Before
let coordinates = (x: 10, y: 20)
let xCoordinate = coordinates.x
let yCoordinate = coordinates.y

/// After
let (_xCoordinate, _yCoordinate) = (x: 10, y: 20)

/// Using Tuples for Multiple Return Values
/// Before
func getCoordinate() -> (Int, Int) {
    return (x: 10, y: 20)
}
let _coordinates = getCoordinate()
let _xCoordinate_ = coordinates.0
let _yCoordinate_ = coordinates.1

// After
func getCoordinates() -> (x: Int, y: Int) {
    return (x: 10, y: 20)
}

let (xcoordinate, ycoordinate) = getCoordinate()


// This example code when create initial name and many more, you can create more Simplifying an example from my code I ever used.
/// Before
func getInitialFrom(string: String) -> String {
    let components = string.components(separatedBy: " ")
    
    if components.count == 1 {
        guard let firstName = components.first else {
            return ""
        }
        return String(firstName.prefix(1))
    }
    
    guard let firstName = components.first, let lastName = components.last else {
        return ""
    }
    
    let firstInitial = String(firstName.prefix(1))
    let lastInitial = String(lastName.prefix(1))
    
    return (firstInitial + lastInitial).uppercased()
}

/// After
func getInitials(from fullName: String) -> String {
    let components = fullName.split(separator: " ")
    let firstInitial = components.first?.prefix(1) ?? ""
    let lastInitial = (components.count > 1) ? (components.last?.prefix(1) ?? "") : ""
    
    return (firstInitial + lastInitial).uppercased()
}

// You can also create extensions for multiple uses like this. I think I use this often.
extension String {
    func getInitials() -> String {
        let components = self.split(separator: " ")
        let firstInitial = components.first?.prefix(1) ?? ""
        let lastInitial = (components.count > 1) ? (components.last?.prefix(1) ?? "") : ""
        
        return (firstInitial + lastInitial).uppercased()
    }
}
