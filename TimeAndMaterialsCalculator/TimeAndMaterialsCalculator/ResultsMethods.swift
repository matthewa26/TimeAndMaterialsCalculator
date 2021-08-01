//
//  ResultsMethods.swift
//  TimeAndMaterialsCalculator
//
//  Created by Matthew Ayers on 7/31/21.
//

import Foundation

// MARK: Get Call Type
// Return index 0: call value, 1: call type, 2: call value text
func getCallType(when charged: Bool, and overtime: Bool) -> (Double, String, String) {
    var text = ""
    var callCost = 0.00
    
    // Determines appropriate call charge
    if charged {
        text = "Regular"
        callCost = 75.00
    } else {
        text = "No Service Call Charge"
        // callCost already set to 0.00
    }
    
    // Overrides other options
    if overtime {
        text = "Overtime"
        callCost = 100.00
    }
    
    return (callCost, text, String(format: "%.2f", callCost))
}

// MARK: Get Material Calculation
func getMaterialCalculation(for material: Material, and discountsAdded: Bool = true) -> (Double, String, String) {
    print("\nMaterial: \(material.name)")
    
    // Initial price
    var materialTotal = material.price
    let materialPriceText = "$\(String(format: "%.2f", material.price))"
    print("getMaterialCalculation: original material price: $\(materialTotal)")
    
    // Multiplies cost by quantity
    materialTotal = materialTotal * Double(material.quantity)
    let quantityText = " * \(material.quantity)"
    
    // Adds tax to material cost
    let taxPercentText = applyTaxPercent(when: material.markup, to: materialTotal).1
    materialTotal = applyTaxPercent(when: material.markup, to: materialTotal).0
    print("getMaterialCalculation: price after tax: $\(materialTotal)")
    
    // Adds markup to material cost
    let markupText = material.markup ? " * \(applyMarkup(when: material.markup, to: materialTotal))" : ""
    materialTotal *= applyMarkup(when: material.markup, to: materialTotal)
    print("getMaterialCalculation: price if marked up: $\(materialTotal) (\(material.markup))")
    
    // Rounds up to nearest $5 increment
    let oldMaterialTotal = materialTotal
    materialTotal = applyRounding(to: materialTotal, when: material.markup)
    let materialRoundingText = material.markup ? " + $\(String(format: "%.2f", materialTotal - oldMaterialTotal))" : ""
    print("getMaterialCalculation: price after rounding: $\(materialTotal)")
    
    // Applies scheduled service discount when appropriate
    let totalWithoutDiscounts = materialTotal
    if discountsAdded {
        materialTotal = applyScheduledServiceDiscount(when: material.scheduledServiceDiscount, to: materialTotal)
    }
    let scheduledServiceDiscountText = material.scheduledServiceDiscount ? "" : ""
    print("getMaterialCalculation: price with potential SS discount: $\(materialTotal) (\(material.scheduledServiceDiscount))")
    
    // Assembles material calculation text
    let materialCalculationText = "\(materialPriceText)\(quantityText)\(taxPercentText)\(markupText)\(materialRoundingText)\(scheduledServiceDiscountText) = "
    print("getMaterialCalculation: material calculation text: \"\(materialCalculationText)\"")
    
    return (materialTotal, materialCalculationText, String(format: "$%.2f", totalWithoutDiscounts))
}

// MARK: Material Discount
func getMaterialDiscount(for material: Material) -> (Double) {
        
    // Determines material cost without any discounts
    let materialCost: Double = getMaterialCalculation(for: material, and: false).0
    
    // Determines material cost with discounts
    let materialCostWithDiscount: Double = getMaterialCalculation(for: material, and: true).0
    print("getMaterialDiscount: Material cost with discount: $\(materialCostWithDiscount)")
    
    // Calculates discount amount
    let materialDiscount: Double = materialCost - materialCostWithDiscount
    print("getMaterialDiscount: Material discount: $\(materialDiscount)")
    
    return (materialDiscount)
}

// MARK: Apply Tax Percent
func applyTaxPercent(when materialIsMarkedUp: Bool, to price: Double) -> (Double, String) {
    let taxRate = 0.0685
    var text = ""
    var newPrice = price
    
    if materialIsMarkedUp {
        newPrice *= (1.0 + taxRate)
        text =  String(format: " + %.2f%%", taxRate * 100.0)
    }

    return (newPrice, text)
}

// MARK: Apply Markup
func applyMarkup(when materialIsMarkedUp: Bool, to initialPrice: Double) -> Double {
    
    // Default value if there is no markup
    var markupMultiplier = 1.0
    
    // Determines value if there is a markup
    if materialIsMarkedUp {
        if initialPrice <= 5.99 {
            markupMultiplier = 6.0
        } else if initialPrice <= 29.99 {
            markupMultiplier = 4.0
        } else if initialPrice <= 89.99 {
            markupMultiplier = 3.0
        } else if initialPrice <= 199.99 {
            markupMultiplier = 2.50
        } else if initialPrice <= 499.99 {
            markupMultiplier = 2.0
        } else {
            markupMultiplier = 1.7
        }
    }
    
    return markupMultiplier
}

// MARK: Apply SS Discount
func applyScheduledServiceDiscount(when discountApplies: Bool, to price: Double) -> Double {
    var discountedPrice = price
    
    print("applyScheduledServiceDiscount: Price before potential SS Discount: $\(discountedPrice)")
    print("applyScheduledServiceDiscount: Discount applied: \(discountApplies)")
    
    if discountApplies {
        discountedPrice *= 0.9
    }
    
    print("applyScheduledServiceDiscount: Price after potential SS Discount: $\(discountedPrice)")
    
    return discountedPrice
}

// MARK: Apply Rounding
func applyRounding(to price: Double, when priceIsMarkedUp: Bool) -> Double {
    // Original price
    var roundedPrice = price

    // Nearest dollar increment to round to
    let roundTo = 1
    
    if priceIsMarkedUp {
        // Rounds up to the next whole number
        roundedPrice = ceil(price)
        
        // Rounds up to roundTo amount
        // Fun Fact: Comment the next line out to round to the nearest whole number.
        roundedPrice += Double(roundTo - (Int(roundedPrice) % roundTo))
    }
    
    return roundedPrice
}

// MARK: Price With Tax
func priceWithTax(initialPrice: Double) -> Double {
    let taxPercentage = 1.0685
    return initialPrice * taxPercentage
}

// MARK: Get Total Materials Cost
func getTotalMaterialsCost(call: Call) -> (Double, String) {
    
    var totalMaterialsCost = 0.00
    
    // Calculates cost without discounts for each material
    for material in call.materials {
        totalMaterialsCost += getMaterialCalculation(for: material, and: false).0
    }
    print("getTotalMaterialsCost: Total materials cost: $\(totalMaterialsCost)")
    
    return (totalMaterialsCost, String(format: "%.2f", totalMaterialsCost))
}

// MARK: Get Total Materials Discount
func getTotalMaterialsDiscount(call: Call) -> (Double, String) {
    
    var totalMaterialsDiscount = 0.00
    
    // Calculates material discount for each material
    for material in call.materials {
        totalMaterialsDiscount += getMaterialDiscount(for: material)
    }
    print("getTotalMaterialsDiscount: Total materials discount: $\(totalMaterialsDiscount)")
    
    return (totalMaterialsDiscount, String(format: "%.2f", totalMaterialsDiscount))
}

// MARK: Get Total Hours
func getTotalHours(call: Call) -> (Double) {
    var totalHours = Double(call.time) / 60.0
    
    // Overtime must have a minimum of one hour
    if (call.overtime && totalHours < 1.00) {
        totalHours = 1.00
    }
    
    print("getTotalHours: Total hours: \(totalHours)")
    
    return totalHours
}

// MARK: Get Total Labor Cost
func getTotalLaborCost(call: Call) -> (Double, String, String) {
    
    // Determines hourly rate and total hours worked
    let hourlyRate = call.overtime ? 100.00 : 80.00
    let totalHours = getTotalHours(call: call)
    
    // Determines total labor cost
    let totalLaborCost = hourlyRate * totalHours
    let totalLaborText = "$\(String(format: "%.2f", hourlyRate)) * \(String(format: "%.2f", totalHours)) hours = "
    
    return (totalLaborCost, totalLaborText, String(format: "$%.2f", totalLaborCost))
}

// MARK: Get Grand Total
func getGrandTotal(call: Call) -> String {
    
    var grandTotal = 0.00
    
    // Adds service call charge to total
    grandTotal += getCallType(when: call.serviceCallCharge, and: call.overtime).0
    print("getGrandTotal: grand total after call type: \(grandTotal)")
    
    // Adds cost of all materials less all discounts
    grandTotal += (getTotalMaterialsCost(call: call).0 - getTotalMaterialsDiscount(call: call).0)
    print("getGrandTotal: grand total after adding all materials: \(grandTotal)")
    
    // Adds cost of labor
    grandTotal += getTotalLaborCost(call: call).0
    print("getGrandTotal: grand total: \(grandTotal)")
    
    // Formats grand total output
    return String(format: "%.2f", grandTotal)
}
     
