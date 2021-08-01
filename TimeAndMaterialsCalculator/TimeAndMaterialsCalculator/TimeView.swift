//
//  TimeView.swift
//  TimeAndMaterialsCalculator
//
//  Created by Matthew Ayers on 7/31/21.
//

import SwiftUI

struct TimeView: View {
    
    @ObservedObject var call: Call
    @ObservedObject var store: DataStore
    
    // State variables here
    @State var timeWorked = 0
    @State var overtime: Bool = false
    @State var scheduledService = true
    let minuteIncrements = [0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330, 360, 390, 420, 450, 480, 510, 540, 570, 600]
    
    var body: some View {
            VStack {
                Form {
                    
                    // MARK: Call Options
                    Section(header: Text("Call Options")) {
                        Toggle("Overtime Call", isOn: $overtime)
                            .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
                        Toggle("Include service call charge", isOn: $scheduledService)
                            .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
                    }
                    
                    // MARK: Hrs/Mins Worked
                    Section(header: Text("Hours Worked")) {
                        Picker("Hours", selection: $timeWorked ) {
                            ForEach(0 ..< minuteIncrements.count) {
                                Text("\(String(format: "%.2f", Double(self.minuteIncrements[$0])/60.0)) hours")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    
                    // MARK: Nav Link: Results
                    NavigationLink(destination: ResultsView(call: call, store: store)) {
                        Text("Continue to Results")
                    }
                }
                Spacer()
            }
            .navigationTitle("Time")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                timeWorked = Int(call.time * 60.0)
                overtime = call.overtime
                scheduledService = call.serviceCallCharge
            })
            .onDisappear(perform: {
                call.time = Double(timeWorked) * 30.0 //+ 30.0
                call.overtime = overtime
                call.serviceCallCharge = scheduledService
            })
    }
}

// MARK: Time Enums
enum Time: String, CaseIterable, Identifiable, CustomStringConvertible {
    case regular
    case overtime

    var id: String { self.rawValue }
    var description: String { self.rawValue.localizedCapitalized }
}

enum ServiceCallCharge: String, CaseIterable, Identifiable, CustomStringConvertible {
    case yes
    case no

    var id: String { self.rawValue }
    var description: String { self.rawValue.localizedCapitalized }
}

// MARK: Preview
struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
        TimeView(call: testData[0], store: testStore)
            .preferredColorScheme(.dark)
    }
}
