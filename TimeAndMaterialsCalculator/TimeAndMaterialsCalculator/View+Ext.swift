//
//  View+Ext.swift
//  TimeAndMaterialsCalculator
//
//  Created by Matthew Ayers on 7/31/21.
//

import SwiftUI

extension View {
    public func sheet<Content: View, Value>(
            using value: Binding<Value?>,
            @ViewBuilder content: @escaping (Value) -> Content
        ) -> some View {
            let binding = Binding<Bool>(
                get: { value.wrappedValue != nil },
                set: { _ in value.wrappedValue = nil }
            )
            return sheet(isPresented: binding) {
                content(value.wrappedValue!)
            }
        }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
