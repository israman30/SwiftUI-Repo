import UIKit
import Foundation

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
    return [0 , 0]
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
for i in 0...10 {
    print(fibonacci(num: i))
}
