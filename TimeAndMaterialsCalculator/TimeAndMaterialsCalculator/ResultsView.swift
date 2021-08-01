//
//  ResultsView.swift
//  TimeAndMaterialsCalculator
//
//  Created by Matthew Ayers on 7/31/21.
//

import SwiftUI

// MARK: Main Results View
struct ResultsView: View {
    
    @ObservedObject var call: Call
    @ObservedObject var store: DataStore
    
    var body: some View {
        VStack {
            List {
                // Each cell type can be rearranged as needed
                ServiceCallChargeCellView(call: call)
                MaterialsListView(call: call)
                TotalMaterialsAndDiscountsCellView(call: call)
                LaborCellView(call: call)
                GrandTotalCellView(call: call)
                // Return to Main Screen
            }
            .navigationTitle(Text("Results"))
            Spacer()
            NavigationLink(destination: ContentView(store: store)) {
                Text("New Calculation")
            }
            .buttonStyle(BigButtonStyle())
            .padding()
        }
    }
}

// MARK: Service Call Charge Cell
struct ServiceCallChargeCellView: View {
    
    @ObservedObject var call: Call
    
    var body: some View {
        VStack {
            HStack {
                Text("Call Type: ")
                    .fontWeight(.bold)
                Spacer()
                // "Regular", "Overtime", or "No Service Call Charge"
                Text("\(getCallType(when: call.serviceCallCharge, and: call.overtime).1)")
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
            HStack {
                Text("Cost for Call: ")
                    .fontWeight(.bold)
                Spacer()
                // "Regular", "Overtime", or "No Service Call Charge"
                Text("$\(getCallType(when: call.serviceCallCharge, and: call.overtime).2)")
                    .fontWeight(.semibold)
            }
        }
    }
}

// MARK: Materials List Cells
struct MaterialsListView: View {
    
    @ObservedObject var call: Call
    
    var body: some View {
        ForEach(call.materials) { material in
            VStack {
                HStack {
                    Text("\(material.name) \u{00D7}\(material.quantity)\(material.scheduledServiceDiscount ? " (discounted)" : "")")
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("\(getMaterialCalculation(for: material, and: true).1)")
                        .font(.caption)
                    Text("\(getMaterialCalculation(for: material, and: true).2)")
                }
            }
        }
    }
    
}

// MARK: Total Materials/Discounts
struct TotalMaterialsAndDiscountsCellView: View {
    
    @ObservedObject var call: Call
    
    var body: some View {
        VStack {
            HStack {
                Text("Total Job Materials: ")
                    //.fontWeight(.bold)
                Spacer()
                Text("$\(getTotalMaterialsCost(call: call).1)")
            }
            HStack {
                Text("Total SS Discount: ")
                    //.fontWeight(.bold)
                Spacer()
                Text("$\(getTotalMaterialsDiscount(call: call).1)")
            }
            HStack {
                Text("Subtotal After All Discounts: ")
                    .fontWeight(.bold)
                Spacer()
                Text("$\(String(format: "%.2f", (getTotalMaterialsCost(call: call).0 - getTotalMaterialsDiscount(call: call).0)))")
                    .fontWeight(.bold)
            }
        }
    }
}

// MARK: Labor Cell
struct LaborCellView: View {
    
    @ObservedObject var call: Call
    
    var body: some View {
        HStack {
            Text("Labor: ")
                .fontWeight(.bold)
            Spacer()
            Text("\(getTotalLaborCost(call: call).1)")
                .font(.caption)
            Text("\(getTotalLaborCost(call: call).2)")
                .fontWeight(.bold)
        }
    }
}

// MARK: Grand Total Cell
struct GrandTotalCellView: View {
    
    @ObservedObject var call: Call
    
    var body: some View {
        VStack {
            Divider()
                .padding(.horizontal, 0)
                .frame(height: 3.0)
                .background(Color.primary)
            HStack {
                Text("Total Without Discounts: ")
                    .fontWeight(.heavy)
                Spacer()
                Text("\(String(format: "$%.2f", ((Double(getGrandTotal(call: call)) ?? 0) + getTotalMaterialsDiscount(call: call).0)))")
                    .fontWeight(.heavy)
            }
            HStack {
                Text("Total With Discounts: ")
                    .fontWeight(.heavy)
                Spacer()
                Text("$\(getGrandTotal(call: call))")
                    .fontWeight(.heavy)
            }
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(call: testStore.calls[0], store: testStore)
            .preferredColorScheme(.dark)
    }
}
