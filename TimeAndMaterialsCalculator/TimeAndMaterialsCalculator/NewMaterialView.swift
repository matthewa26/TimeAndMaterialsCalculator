//
//  NewMaterialView.swift
//  TimeAndMaterialsCalculator
//
//  Created by Matthew Ayers on 7/31/21.
//

import SwiftUI

struct NewMaterialView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var call: Call
    
    @State var materialName = ""
    @State var materialQuantity = ""
    @State var materialPrice = ""
    @State var markup: Bool = false
    @State var scheduledServiceMaterial: Bool = false
    @State var buttonDisabled = true
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    
                    // MARK: Name
                    Section(header: Text("Material Name")) {
                        HStack {
                            TextField("Name", text: $materialName)
                                .keyboardType(.default)
                            if materialName != "" {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.medium)
                                    .foregroundColor(.secondary)
                                    .padding(2)
                                    .onTapGesture {
                                        withAnimation {
                                            materialName = ""
                                        }
                                    }
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    
                    // MARK: Price
                    Section(header: Text("Material Price")) {
                        HStack {
                            Text("$").foregroundColor(.secondary)
                            TextField("0.00", text: $materialPrice)
                                .keyboardType(.decimalPad)
                            if materialPrice != "" {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.medium)
                                    .foregroundColor(.secondary)
                                    .padding(2)
                                    .onTapGesture {
                                        withAnimation {
                                            materialPrice = ""
                                        }
                                    }
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    
                    // MARK: Quantity
                    Section(header: Text("Material Quantity")) {
                        HStack {
                            TextField("0", text: $materialQuantity)
                                .keyboardType(.numberPad)
                            if materialQuantity != "" {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.medium)
                                    .foregroundColor(.secondary)
                                    .padding(2)
                                    .onTapGesture {
                                        withAnimation {
                                            materialQuantity = ""
                                        }
                                    }
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    
                    // MARK: Discounts/Markups
                    Section(header: Text("Options")) {
                        Toggle("Scheduled Service Material", isOn: $scheduledServiceMaterial)
                            .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
                    }
                }
            }
            // MARK: View Modifications
            .onTapGesture {hideKeyboard()}
            .navigationBarTitle("Add Material")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading ) {
                    Button("Cancel") {
                        // Hide SheetView
                        presentationMode.wrappedValue.dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Hide SheetView
                        presentationMode.wrappedValue.dismiss()
                        
                        // Add item to data store
                        call.addItem(Material(name: materialName, price: (materialPrice as NSString).doubleValue, quantity: (materialQuantity as NSString).integerValue, markup: markup, scheduledServiceDiscount: scheduledServiceMaterial))
                        
                        // Show drop notification message
                        showDrop()
                    }
                    // Determines if save button is active
                    .disabled(incompleteMaterialInformation(name: materialName, price: materialPrice, quantity: materialQuantity))
                }
            }
        }
    }
}

// MARK: Preview
struct NewMaterialView_Previews: PreviewProvider {
    static var previews: some View {
        NewMaterialView(call: testData[0])
    }
}
