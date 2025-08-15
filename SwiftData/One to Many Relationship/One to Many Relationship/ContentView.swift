//
//  ContentView.swift
//  One to Many Relationship
//
//  Created by Israel Manzo on 8/14/25.
//

import SwiftUI
import SwiftData

@Model
class Owner {
    var name: String
    var cars: [Car] = []
    
    init(name: String) {
        self.name = name
    }
}

@Model
class Car {
    var make: String
    var registrationNumber: String
    var owner: Owner?
    
    init(make: String, registrationNumber: String, owner: Owner? = nil) {
        self.make = make
        self.registrationNumber = registrationNumber
        self.owner = owner
    }
}

struct CarList: View {
    // Access the SwiftData model context (used for saving/deleting data)
    @Environment(\.modelContext) private var modelContext
    
    // The specific Owner whose cars we are displaying
    var owner: Owner?
    
    // Form input states
    @State private var make = ""
    @State private var registrationNumber = ""
    @State private var selectedCar: Car?
    
    // Computed property: true if editing an existing car
    var isEditing: Bool {
        selectedCar != nil
    }
    
    @Query private var cars: [Car]
    
    var body: some View {
        VStack {
            GroupBox {
                VStack {
                    TextField("Car Model", text: $make)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Registration number", text: $registrationNumber)
                        .textFieldStyle(.roundedBorder)
                    
                    HStack {
                        // Show cancel button only if editing
                        if isEditing {
                            Button("Cancel") {
                                selectedCar = nil
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        // Add or update button based on mode
                        Button(isEditing ? "Update" : "Add") {
                            if isEditing {
                                // Update the selected car's details
                                selectedCar?.make = make
                                selectedCar?.registrationNumber = registrationNumber
                            } else {
                                // Create a new car and attach it to the owner
                                let car = Car(make: make, registrationNumber: registrationNumber, owner: owner)
                                owner?.cars.append(car)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(make.isEmpty || registrationNumber.isEmpty)
                        
                    }
                }
            }
            .padding()
        }
        
        List {
            ForEach(owner?.cars ?? []) { car in
                VStack(alignment: .leading) {
                    Text(car.make)
                        .font(.headline)
                    Text(car.registrationNumber)
                        .foregroundStyle(.secondary)
                }
                .onTapGesture {
                    // Populate form with existing car data for editing
                    selectedCar = car
                    make = car.make
                    registrationNumber = car.registrationNumber
                }
                
            } // Handle delete action from swipe gesture
            .onDelete { indexSet in
                indexSet.forEach { index in
                    if let car = owner?.cars[index] {
                        // Remove from owner's array
                        owner?.cars.removeAll { $0.id == car.id }
                        // Remove from database
                        modelContext.delete(car)
                    }
                }
            }
            
        }
    }
    
    private func resetForm() {
        make = ""
        registrationNumber = ""
        selectedCar = nil
    }
}

struct ContentView: View {
    
    var body: some View {
        CarList()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
