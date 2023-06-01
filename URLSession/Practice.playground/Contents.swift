import UIKit
import Foundation

struct User: Decodable {
    let name: String
}

extension Decodable {
    static func decode(data: Data) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
}
let user = try? User.decode(data: Data())

var nums = [0, 1, 0, 2, 3, 0]
// [0, 0, 0, 1, 2, 3]

//func isPalindrome(str: String) -> Bool {
//    var str = Array(str)
//    for i in 0..<str.count / 2 {
//        if str[i] == str[str.count - 1 - i] {
//            return true
//        }
//    }
//    return false
//}
//
//func hasPalindrome(sentence: String) -> Bool {
//    var counts = [String:Int]()
//    let words = sentence.components(separatedBy: " ")
//    words.forEach { word in
//        if isPalindrome(str: word) {
//            let count = counts[word] ?? 0
//            counts[word] = count + 1
//        }
//        print(counts.values)
//    }
//    for (_, value) in counts {
//        if value >= 1 {
//            return true
//        }
//    }
//    return false
//}
//
//hasPalindrome(sentence: "Hello anna")

//palindrome(str: "anna")

var numeros = [0, 3, 5, 1, 2]

func insertSort(arr: [Int]) -> [Int] {
    var arr = arr
    for i in 0..<arr.count {
        var value = arr[i]
        var position = i - 1
        while position >= 0 && arr[position] > value {
            arr[position + 1] = arr[position]
            position -= 1
        }
        arr[position + 1] = value
    }
    return arr
}

func insertSort2(arr: [Int]) -> [Int] {
    var sortedArr = arr
    for index in 1..<sortedArr.count {
        var currentIndex = index
        while currentIndex > 0 && sortedArr[currentIndex] < sortedArr[currentIndex - 1] {
            sortedArr.swapAt(currentIndex - 1, currentIndex)
            currentIndex -= 1
        }
    }
    return sortedArr
}
//insertSort2(arr: numeros)
//insertSort(arr: numeros)

func quickSort(arr: [Int]) -> [Int] {
    var less = [Int]()
    var equal = [Int]()
    var greater = [Int]()
    
    guard arr.count > 1 else { return arr }
    let pivot = arr[arr.count / 2]
    for number in arr {
        if number < pivot {
            less.append(number)
        } else if number == pivot {
            equal.append(number)
        } else {
            greater.append(number)
        }
    }
    return quickSort(arr: less) + equal + quickSort(arr: greater)
}

func quickSort2(num: [Int]) -> [Int] {
    guard num.count > 1 else { return num }
    let pivot = num[num.count / 2]
    return quickSort2(num: num.filter {
        $0 < pivot
    }) + num.filter {
        $0 == pivot
    } + quickSort2(num: num.filter {
        $0 > pivot
    })
}
//quickSort2(num: numeros)
//quickSort(arr: numeros)

func twoNumSum(nums: [Int], target: Int) -> [Int] {
    var dict = [Int:Int]()
    for (currentIndex, n) in nums.enumerated() {
        let complement = target - n
        if let complementIndex = dict[complement] {
            return [complementIndex, currentIndex]
        }
        dict[n] = currentIndex
    }
    return [0, 0]
}
//twoNumSum(nums: [2,7,11,15], target: 9)
// 0 1 1 2 3 5 8 13...
func fibonacci(num: Int) -> Int {
    var first = 0
    var second = 1
    var holder = 0
    for _ in 0..<num {
        holder = first
        first = second
        second = holder + second
    }
    return first
}
//for i in 0...10 {
//    print(fibonacci(num: i))
//}

func reverseString(str: String) -> String {
    var word = ""
    for char in str {
        word = "\(char)" + word
    }
    return word
}
//reverseString(str: "hello")
// word = h + "" -> "h"
// word = e + "h" -> "eh"
// word = l + "eh" -> "leh"
// word = l + "leh" -> "lleh"
// word = o " "lleh" -> "olleh"

func findRepeat(arr: [String]) -> Bool {
    var dict = [String:Int]()
    for i in arr {
        if let count = dict[i] {
            dict[i] = count + 1
        } else {
            dict[i] = 1
        }
        print(dict)
    }
    for (_ , value) in dict where value > 1 {
        return true
    }
    return false
}
//findRepeat(arr: ["a", "b", "c", "b", "d"])
/**
 dict["a"] = count + 1 => ["a": 1]
 
 */
func quickSort3(arr: [Int]) -> [Int] {
    guard arr.count > 1 else { return arr }
    let pivot = arr[arr.count / 2]
    return quickSort3(arr: arr.filter { $0 < pivot }) + arr.filter { $0 == pivot } + quickSort3(arr: arr.filter { $0 > pivot })
}
//quickSort3(arr: numeros)

func sumOfTwonumbers(arr: [Int], target: Int) -> [Int] {
    var first = 0
    var last = arr.count - 1
    while first < last {
        let sum = arr[first] + arr[last]
        if target == sum {
            return [arr[first], arr[last]]
        }
        if target > sum {
            first += 1
        } else {
            last -= 1
        }
    }
    return []
}
//sumOfTwonumbers(arr: [1, 2, 3, 4], target: 7)
func sumOfTwoNumbers2(arr: [Int], target: Int) -> [Int] {
    var dict = [Int:Int]()
    for (currentIndex, n) in arr.enumerated() {
        let complement = target - n
        print("complement: \(complement)")
        if let complementIndex = dict[complement] {
            return [complementIndex, currentIndex]
        }
        dict[n] = currentIndex
        print("-->",dict)
    }
    return [0, 0]
}
sumOfTwoNumbers2(arr: [1, 2, 3, 4], target: 7)

//var dict = [String:String]()
//dict["Quito"] = "Ecuador"
//if let city = dict["Quito"] {
//    print(city)
//}
//print(dict)
/**
 7 - 1 = 6 [1 : 0]
 7 - 2 = 5 [2 : 1]
 7 - 3 = 4 [3 : 2]
 7 - 4 = 3 [2 : 3]
 */
class BinaryTree {
    let value: Int
    var left: BinaryTree? = nil
    var right: BinaryTree? = nil
    var parent: BinaryTree? = nil
    
    init(value: Int) {
        self.value = value
    }
}
extension BinaryTree {
    
    func insert(value: Int) {
        if parent == nil {
            parent = BinaryTree(value: value)
            return
        }
        if value < self.value {
            if let left = left {
                left.insert(value: value)
            } else {
                left = BinaryTree(value: value)
                left?.parent = self
            }
        } else {
            if let right = right {
                right.insert(value: value)
            } else {
                right = BinaryTree(value: value)
                right?.parent = self
            }
        }
    }
    
    func search(value: Int) -> Bool {
        if value == self.value {
            return true
        }
        if value < self.value {
            if let left {
                return left.search(value: value)
            }
        } else {
            if let right {
                return right.search(value: value)
            }
        }
        return false
    }
    
    func height() -> Int {
        if self.value == 0 {
            return 0
        }
        return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
    }
    
    func maxDepth(parent: BinaryTree?) -> Int {
        return parent == nil ? 0 : max(maxDepth(parent: parent?.left), maxDepth(parent: parent?.right))
    }
    
    func minimun() -> BinaryTree? {
        var node = self
        while let left = node.left {
            node = left
        }
        return node
    }
    func maximun() -> BinaryTree? {
        var node = self
        while let right = node.right {
            node = right
        }
        return node
    }
    
    func deleteAllLEaft(parent: BinaryTree?) -> BinaryTree? {
        if parent?.left == nil && parent?.right == nil {
            return nil
        }
        parent?.left = deleteAllLEaft(parent: parent?.left)
        parent?.right = deleteAllLEaft(parent: parent?.right)
        return parent
    }
    
    func printInOrderTraverse(parent: BinaryTree?) {
        if left != nil {
            left?.printInOrderTraverse(parent: parent?.left)
        }
        print(value)
        if right != nil {
            right?.printInOrderTraverse(parent: parent?.right)
        }
    }
    func inOrderTraverse(visit: (Int) -> ()) {
        left?.inOrderTraverse(visit: visit)
        visit(value)
        right?.inOrderTraverse(visit: visit)
    }
    func inOrderRetunrArray(parent: BinaryTree?) -> [Int] {
        if parent == nil {
            return []
        }
        var inorder = [Int]()
        inorder += inOrderRetunrArray(parent: parent?.left)
        inorder.append(parent!.value)
        inorder += inOrderRetunrArray(parent: parent?.right)
        return inorder
    }
}
let tree = BinaryTree(value: 5)
tree.insert(value: 10)
tree.insert(value: 4)


func reverseArray(arr: [Int]) -> [Int] {
    var arr = arr
    for i in 0..<arr.count / 2 {
        arr.swapAt(i, arr.count - 1 - i)
    }
    return arr
}
