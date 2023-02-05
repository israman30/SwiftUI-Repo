//
//  ContentView.swift
//  URLIntro-ONE
//
//  Created by Israel Manzo on 1/31/23.
//

import SwiftUI

struct ContentView: View {
    
    let operation = CalculatePrimeOperation()
    @State var calculateDisable = false
    
    var body: some View {
        VStack {
            Spacer()
            Button { calculatePrime() } label: {
                Text("Calculate the time")
            }.disabled(calculateDisable)

            DatePicker(selection: .constant(Date()), label: {
                Text("Date")
            })
            .labelsHidden()
            .pickerStyle(.wheel)
            
            Spacer()
        }
        .padding()
    }
    
    func calculatePrime() {
        calculateDisable = true
        DispatchQueue.global(qos: .userInitiated).async {
            for number in 0...1_000_000 {
                let isPrimeNumber = self.isPrime(number: number)
                print("\(number) is prime: \(isPrimeNumber)")
            }
            self.calculateDisable = false
        }
        
//        let queue = OperationQueue()
//        queue.addOperation {
//            for number in 0...1_000_000 {
//                let isPrimeNumber = self.isPrime(number: number)
//                print("\(number) is prime: \(isPrimeNumber)")
//            }
//        }
        
        
    }
    
    func isPrime(number: Int) -> Bool {
        if number <= 1 {
            return false
        }
        var i = 2
        while i * i <= number {
            if number % i == 0 {
                return false
            }
            i = i + 2
        }
        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
