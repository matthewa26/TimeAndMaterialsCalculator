//
//  Data.swift
//  TimeAndMaterialsCalculator
//
//  Created by Matthew Ayers on 7/31/21.
//

import Foundation
import Combine

class DataStore: ObservableObject {
    @Published var calls: [Call]
    @Published var overtimeEnabled: Bool = false
    @Published var overtimeSurcharge: Double = 0.00
    @Published var salesTaxRate: Double = 0.00
    @Published var discountRate: Double = 0.00
    
    init(calls: [Call] = []) {
        self.calls = calls
        
        if self.calls.isEmpty {
            self.calls.append(.init(materials: [], time: 0, overtime: false, scheduledService: true))
        }
    }
}

let testStore = DataStore(calls: testData)

class Call: Identifiable, ObservableObject {
    @Published var id = UUID()
    @Published var name = ""
    @Published var materials: [Material]
    @Published var time: Double = 0.0
    @Published var overtime: Bool = false
    @Published var serviceCallCharge: Bool = true
    @Published var addNewMaterial: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init(materials: [Material], time: Int, overtime: Bool, scheduledService: Bool) {
        self.materials = []
        self.time = 0
        self.overtime = false
        self.serviceCallCharge = true
    }
    
    func addItem(_ material: Material) {
        materials.append(material)
        material.objectWillChange
            .sink(receiveValue: {
                self.objectWillChange.send()
            })
            .store(in: &cancellables)
    }
}

class Material: Identifiable, ObservableObject {
    @Published var id = UUID()
    @Published var name: String
    @Published var price: Double
    @Published var quantity: Int
    @Published var markup: Bool
    @Published var scheduledServiceDiscount: Bool
    
    init(name: String, price: Double, quantity: Int, markup: Bool, scheduledServiceDiscount: Bool) {
        self.name = name
        self.price = price
        self.quantity = quantity
        self.markup = markup
        self.scheduledServiceDiscount = scheduledServiceDiscount
    }
}

let testData = [

    Call(materials: [
        Material(name: "Capacitor", price: 75.00, quantity: 1, markup: true, scheduledServiceDiscount: false),
        Material(name: "16x25x4 Filter", price: 40.00, quantity: 1, markup: true, scheduledServiceDiscount: false)
    ], time: 90, overtime: true, scheduledService: true)

]
