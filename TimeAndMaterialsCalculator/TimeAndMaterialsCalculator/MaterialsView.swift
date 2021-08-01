//
//  MaterialsView.swift
//  TimeAndMaterialsCalculator
//
//  Created by Matthew Ayers on 7/31/21.
//

import SwiftUI

struct MaterialsView: View {
    
    @ObservedObject var call: Call
    @ObservedObject var store: DataStore
    @State var activeSheet: ActiveSheet?

    enum ActiveSheet {
        case addMaterial
    }
    
    // MARK: List of Materials
    var body: some View {
        
        VStack {
            List {
                if (call.materials.count > 0) {
                    ForEach(call.materials) { material in
                        MaterialCellView(material: material)
                    }
                        .onDelete(perform: deleteMaterial)
                    NavigationLink(destination: TimeView(call: call, store: store)) {
                        Text("Continue to Time")
                    }
                } else {
                    Text("Tap 'Add' to list a new material.")
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Opening new material view . . .")
                        activeSheet = .addMaterial
                    }, label: {
                        Text("Add")
                    })
                }
            }
            .navigationTitle("Materials")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(using: $activeSheet) { sheet in
            switch sheet {
            
            case .addMaterial:
                NewMaterialView(call: call)
            }
        }
    }
    
    func deleteMaterial(offsets: IndexSet) {
        call.materials.remove(atOffsets: offsets)
    }
}

// MARK: - MaterialCellView
struct MaterialCellView: View {

    @ObservedObject var material: Material
    @State var cellText: String = ""
    
    var body: some View {
        NavigationLink(destination: MaterialDetailView(material: material)) {
            if #available(macOS 11.0, *) {
                Image(systemName: "barcode")
                    .resizable(capInsets: EdgeInsets(), resizingMode: .tile)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50, alignment: .leading)
                    .foregroundColor(.accentColor)
            } else {
                // Fallback on earlier versions
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(getCellText(name: material.name, quantity: material.quantity))
                    Spacer()
                    Text(String(format: "$%.2f ea.", material.price))
                }
                
                HStack {
                    //Text("Qty: \(material.quantity)")
                    Spacer()
                    Text(material.scheduledServiceDiscount ? "Scheduled Service Material" : "")
                        .font(.italic(.body)())
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
    }
}

// MARK: Preview Info
struct MaterialsView_Previews: PreviewProvider {
    static var previews: some View {
        MaterialsView(call: testData[0], store: testStore)
            .preferredColorScheme(.dark)
    }
}

