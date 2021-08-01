//
//  MaterialsDetailView.swift
//  TimeAndMaterialsCalculator
//
//  Created by Matthew Ayers on 7/31/21.
//

import SwiftUI

struct MaterialDetailView: View {
    @ObservedObject var material: Material
    @State var name: String = ""
    @State var price: String = ""
    @State var quantity: String = ""
    @State var markup: Bool = false
    @State var scheduledServiceDiscount: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Form {
                
                // MARK: Name
                Section(header: Text("Material Name")) {
                    HStack {
                        TextField("Name", text: $name)
                            .keyboardType(.default)
                        if name != "" {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.medium)
                                .foregroundColor(.secondary)
                                .padding(2)
                                .onTapGesture {
                                    self.name = ""
                            }
                        }
                    }
                }
                
                // MARK: Price
                Section(header: Text("Material Price")) {
                    HStack {
                        Text("$").foregroundColor(.secondary)
                        TextField("0.00", text: $price)
                            .keyboardType(.decimalPad)
                        if price != "" {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.medium)
                                .foregroundColor(.secondary)
                                .padding(2)
                                .onTapGesture {
                                    withAnimation {
                                        self.price = ""
                                    }
                                }
                        }
                    }
                    .padding(.vertical, 10)
                }
                
                // MARK: Quantity
                Section(header: Text("Material Quantity")) {
                    HStack {
                        TextField("0", text: $quantity)
                            .keyboardType(.numberPad)
                        if quantity != "" {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.medium)
                                .foregroundColor(.secondary)
                                .padding(2)
                                .onTapGesture {
                                    withAnimation {
                                        self.quantity = ""
                                    }
                                }
                        }
                    }
                    .padding(.vertical, 10)
                }
                
                // MARK: Discounts/Markups
                Section(header: Text("Options")) {
                    Toggle("Scheduled Service Material", isOn: $scheduledServiceDiscount)
                        .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
                    Toggle("Add Markup", isOn: $markup)
                        .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
                }
                
            }
        }
        // MARK: Load/Save Logic
        .navigationBarTitle("Edit Material")
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: {
            name = material.name
            price = String(material.price)
            quantity = String(material.quantity)
            markup = material.markup
            scheduledServiceDiscount = material.scheduledServiceDiscount
        })
        .onTapGesture {
            hideKeyboard()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading ) {
                Button("Cancel") {
                    // Hide MaterialDetailView
                    presentationMode.wrappedValue.dismiss()
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    // Hide MaterialDetailView
                    presentationMode.wrappedValue.dismiss()

                    // Update item in data store
                    material.name = name
                    material.price = (price as NSString).doubleValue
                    material.quantity = (quantity as NSString).integerValue
                    material.markup = markup
                    material.scheduledServiceDiscount = scheduledServiceDiscount

                    // Show drop notification message
                    showDrop()
                }
                // Determines if save button is active
                .disabled(incompleteMaterialInformation(name: name, price: price, quantity: quantity))
            }
        }
    }
}

// MARK: Preview
struct MaterialDetail_Previews: PreviewProvider {
    static var previews: some View {
        MaterialDetailView(material: testData[0].materials[0])
    }
}
