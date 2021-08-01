//
//  ContentView.swift
//  T+M Calculator
//
//  Created by Matthew Ayers on 5/08/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var store: DataStore
    
    var body: some View {
        NavigationView {
            if #available(macOS 11.0, *) {
                VStack {
                    Text("Time and Materials Calculator")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Spacer()
                    
                    // New Calculation Button
                    NavigationLink(destination: MaterialsView(call: store.calls.last!, store: store)) {
                        Text("Start New Calculation")
                    }
                    .onAppear(perform: {
                        store.calls.append(Call(materials: [], time: 0, overtime: false, scheduledService: true))
                    })
                    .buttonStyle(BigButtonStyle())
                    .padding(.bottom, 10)
                    
                    // Tutorial Button
                    NavigationLink(destination: TutorialView()) {
                        Text("Tutorial")
                    }
                    .buttonStyle(BigButtonStyle())

                    NavigationLink(destination: SettingsView(store: store)) {
                        Text("Settings")
                    }
                    .buttonStyle(BigButtonStyle())
                    
                    Spacer()
                } // vstack
            } // if available macOS 11.0 condition
        } // navigation view
        .navigationViewStyle(StackNavigationViewStyle())
    } // var body
} // view

// MARK: Button Styling
struct BigButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(15.0)
    }
}

// MARK: iPad Welcome Screen
struct ChooseActionView: View {
    
    @EnvironmentObject var store: DataStore
    
    var body: some View {
        Text("Start a new calculation below.")
            .font(.largeTitle)
        NavigationLink(destination: MaterialsView(call: testStore.calls[0], store: store)) {
            Text("Start New Calculation")
        }
        .buttonStyle(BigButtonStyle())
        .padding(.bottom, 10)
    }
}

// MARK: ContentView Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: testStore)
            .previewDevice("iPhone 11")
            .preferredColorScheme(.light)
    }
}
