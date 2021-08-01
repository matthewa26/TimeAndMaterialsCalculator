//
//  TutorialView.swift
//  TimeAndMaterialsCalculator
//
//  Created by Matthew Ayers on 7/31/21.
//

import SwiftUI

struct TutorialView: View {
    
    let bullet = "\u{2022}"
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Image("cleaves-appLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    Text("How to Use the T+M Calculator")
                        .font(.title)
                    Text("This tool is for technicians and office staff only. ")
                        .padding(.vertical, 20)
                        .font(.italic(.body)())
                }
                
                VStack {
                    HStack {
                        Text("Requirements")
                            .font(.title2)
                        Spacer()
                    }
                    HStack {
                        Text("\(bullet) Material name, price, quantity, if the material should be marked up, and if it is a scheduled service material.")
                        Spacer()
                    }
                    HStack {
                        Text("\(bullet) Was the call regular or overtime?")
                        Spacer()
                    }
                    HStack {
                        Text("\(bullet) Does this call include a service call charge?")
                        Spacer()
                    }
                    HStack {
                        Text("\(bullet) How many hours were worked?")
                        Spacer()
                    }
                }
                .padding()
                
                VStack {
                    HStack {
                        Text("Materials")
                            .font(.title2)
                        Spacer()
                    }
                    Text("To add a new material, tap the 'Add' button and enter the details about the material. Be sure to adjust the markups and discounts correctly so that the materials are priced correctly. All markups and discounts will be automatically applied based on this. After all materials have been added, tap 'Continue to Time' to move to the next step.")
                }
                .padding()
                
                VStack {
                    HStack {
                        Text("Time")
                            .font(.title2)
                        Spacer()
                    }
                    Text("To enter the time, indicate if the call is a regular call or overtime, as well as if a service call charge should be included in the price. After that, adjust the hours worked to the appropriate number. When all of the information is filled out, tap 'Continue to Results' to finish the calculation.")
                }
                .padding()
                
                VStack {
                    HStack {
                        Text("Results")
                            .font(.title2)
                        Spacer()
                    }
                    Text("The results will show the call type, the cost for the call, the total hours, the calculations for each material used, and the grand total. If any material information is missing, a message will appear asking to complete the information to accurately calculate the cost of time and materials. The time will need to be re-entered after adjusting the materials.")
                }
                .padding()
                
//                Text("In order to use this calculator, you will need the following items:\n- Type of hours worked\n- Number of hours worked\n- Material information (name, quantity, price)")
//                    .padding(.bottom, 15)
//                VStack {
//                    Text("Materials")
//                        .font(.title2)
//                    Text("Each material should be entered by itself. Please specify the quantity, price, and whether it is an inventory item or non-inventory item.")
//                }
//                .padding(.bottom, 15)
//                VStack {
//                    Text("Time")
//                        .font(.title2)
//                    Text("Please indicate whether the time worked was regular or overtime and if the customer is a scheduled service customer. Below that, please enter the number of hours and the number of minutes worked.")
//                }
//                .padding(.bottom, 15)
                
                
//                VStack {
//                    Text("Results")
//                        .font(.title2)
//                    Text("The results will do x, y, and z.")
//                }
                Spacer()
            }
        }
        .navigationBarTitle("T+M Calculator Tutorial")
        .navigationBarTitleDisplayMode(.inline)
    }

}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
            .preferredColorScheme(.dark)
    }
}
