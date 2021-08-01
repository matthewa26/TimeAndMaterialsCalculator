//
//  SettingsView.swift
//  TimeAndMaterialsCalculator
//
//  Created by Matthew Ayers on 7/31/21.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var store: DataStore
    @State var overtimeEnabled = true
    @State var salesTaxRate = ""
    @State var discountRate = ""
    @State var overtimeSurcharge = ""
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Overtime Calls")) {
                    HStack {
                        Toggle("Overtime Calls Enabled", isOn: $overtimeEnabled)
                    }
                    if overtimeEnabled {
                        HStack {
                            Text("Overtime Surcharge")
                            Spacer()
                            Text("$")
                            TextField("12.34", text: $overtimeSurcharge)
                                .keyboardType(.decimalPad)
                        }
                    }
                }
                
                Section(header: Text("Sales Tax")) {
                    HStack {
                        Text("Sales Tax Rate")
                        Spacer()
                        TextField("1.234", text: $salesTaxRate)
                            .keyboardType(.decimalPad)
                        Text("%")
                    }
                }
                
                Section(header: Text("Discounts")) {
                    HStack {
                        Text("Discount Rate")
                        Spacer()
                        TextField("12.34", text: $discountRate)
                            .keyboardType(.decimalPad)
                        Text("%")
                    }
                }
            }
        }
        .navigationBarTitle("Settings")
        .onAppear(perform: {
            overtimeEnabled = store.overtimeEnabled
            overtimeSurcharge = String(format: "%.2f", store.overtimeSurcharge)
            salesTaxRate = String(format: "%.2f", store.salesTaxRate)
            discountRate = String(format: "%.2f", store.discountRate)
        })
        .onDisappear(perform: {
            store.overtimeEnabled = overtimeEnabled
            store.overtimeSurcharge = (overtimeSurcharge as NSString).doubleValue
            store.salesTaxRate = (salesTaxRate as NSString).doubleValue
            store.discountRate = (discountRate as NSString).doubleValue
        })
    }
}
