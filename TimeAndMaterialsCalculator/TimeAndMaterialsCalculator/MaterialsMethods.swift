//
//  MaterialsMethods.swift
//  TimeAndMaterialsCalculator
//
//  Created by Matthew Ayers on 7/31/21.
//

import Foundation
import Drops

// MARK: showDrop
func showDrop() {

    let title = "Material Successfully Saved"
    let subtitle = "Your material was successfully saved."
    let position: Drop.Position = .top


    let drop = Drop(
        title: title,
        subtitle: subtitle,
        position: position,
        duration: .seconds(1.0)
    )
    Drops.show(drop)
}

// MARK: Incomplete Material Info?
func incompleteMaterialInformation(name: String, price: String, quantity: String) -> Bool {
    // Determines if every form field in has been filled out
    return !(name != "" && price != "" && quantity != "")
}

// MARK: Get Cell Text
func getCellText(name: String, quantity: Int) -> String {
    
    var text: String
    
    if name != "" {
        text = "\(name) \u{00D7}\(quantity)"
    } else {
        text = "Tap to add details"
    }
    
    return text
}
