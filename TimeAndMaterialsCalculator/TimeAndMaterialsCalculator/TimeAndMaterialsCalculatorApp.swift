//
//  TimeAndMaterialsCalculatorApp.swift
//  TimeAndMaterialsCalculator
//
//  Created by Matthew Ayers on 7/31/21.
//

import SwiftUI

@main
struct TimeAndMaterialsCalculatorApp: App {
    @StateObject private var store = DataStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}
