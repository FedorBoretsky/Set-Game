//
//  RulesView.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 15.04.2021.
//

import SwiftUI

struct RulesView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0){
            HStack {
                Spacer()
                Button{
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                }
            }
            .padding()
            .background(Color.black.opacity(0.066))
            
            
            ScrollView(.vertical){
                VStack(alignment: .leading) {
                    
                    //
                    // Section: Goal
                    //
                    VStack(alignment: .leading) {
                        Text("Goal").rulesH1()

                        Text("The object of the game is to identify a SET of 3 cards from 12 cards placed face-up on the table.").rulesP()
                    }
//
//                    //
//                    // Section: What is 'Set'
//                    //
//                    VStack(alignment: .leading, spacing: 0) {
                        Text("What is 'Set'").rulesH1()
//
                    Text("Each card has 4 features: color, shape, number, and filling style. A SET consists of 3 cards in which every feature a) either all the same, or b) all different. All of the features must separately satisfy this rule.").rulesP()
                    
//                    Text("Each card has four features, each feature has three variations. A SET consists of 3 cards in which every feature a) either all the same, or b) all different. All of the features must separately satisfy this rule.").rulesP()
//
//                        // Table of features
//                        Group{
//
//                            HStack {
//                                VStack {
//                                    ZStack {
//                                        RulesCardView(color: .red, number: .one, shape: .oval, shading: .solid).hidden()
//                                        Text("COLOR").rulesRowTitle()
//                                    }
//                                    Text(" ").rulesImageCaption()
//                                }
//                                VStack {
//                                    RulesCardView(color: .green, number: .one, shape: .squiggle, shading: .solid)
//                                    Text("Green").rulesImageCaption()
//                                }
//                                VStack {
//                                    RulesCardView(color: .purple, number: .one, shape: .squiggle, shading: .solid)
//                                    Text("Purple").rulesImageCaption()
//                                }
//                                VStack {
//                                    RulesCardView(color: .red, number: .one, shape: .squiggle, shading: .solid)
//                                    Text("Red").rulesImageCaption()
//                                }
//                            }.rulesTableOfFeatureRow()
//
//
//                            HStack(alignment: .bottom) {
//                                VStack {
//                                    ZStack {
//                                        RulesCardView(color: .red, number: .one, shape: .oval, shading: .solid).hidden()
//                                        Text("SHAPE").rulesRowTitle()
//                                    }
//                                    Text(" ").rulesImageCaption()
//                                }
//                                VStack {
//                                    RulesCardView(color: .red, number: .one, shape: .oval, shading: .solid)
//                                    Text("Oval").rulesImageCaption()
//                                }
//                                VStack {
//                                    RulesCardView(color: .red, number: .one, shape: .squiggle, shading: .solid)
//                                    Text("Squiggle") .rulesImageCaption()
//                                }
//                                VStack {
//                                    RulesCardView(color: .red, number: .one, shape: .diamond, shading: .solid)
//                                    Text("Diamond").rulesImageCaption()
//                                }
//                            }.rulesTableOfFeatureRow()
//
//
//                            HStack {
//                                VStack {
//                                    ZStack {
//                                        RulesCardView(color: .red, number: .one, shape: .oval, shading: .solid).hidden()
//                                        Text("NUMBER").rulesRowTitle()
//                                    }
//                                    Text(" ").rulesImageCaption()
//                                }
//                                VStack {
//                                    RulesCardView(color: .purple, number: .one, shape: .squiggle, shading: .solid)
//                                    Text("One").rulesImageCaption()
//                                }
//                                VStack {
//                                    RulesCardView(color: .purple, number: .two, shape: .squiggle, shading: .solid)
//                                    Text("Two").rulesImageCaption()
//                                }
//                                VStack {
//                                    RulesCardView(color: .purple, number: .three, shape: .squiggle, shading: .solid)
//                                    Text("Three").rulesImageCaption()
//                                }
//                            }.rulesTableOfFeatureRow()
//
//
//                            HStack {
//                                VStack {
//                                    ZStack {
//                                        RulesCardView(color: .red, number: .one, shape: .oval, shading: .solid).hidden()
//                                        Text("SHADING").rulesRowTitle()
//                                    }
//                                    Text(" ").rulesImageCaption()
//                                }
//                                VStack {
//                                    RulesCardView(color: .green, number: .two, shape: .diamond, shading: .solid)
//                                    Text("Solid").rulesImageCaption()
//                                }
//                                VStack {
//                                    RulesCardView(color: .green, number: .two, shape: .diamond, shading: .striped)
//                                    Text("Striped").rulesImageCaption()
//                                }
//                                VStack {
//                                    RulesCardView(color: .green, number: .two, shape: .diamond, shading: .open)
//                                    Text("Outlined").rulesImageCaption()
//                                }
//                            }.rulesTableOfFeatureRow()
//                        }.rulesExampleBlock()
//
//                        Text("A SET consists of 3 cards in which every feature a) either all the same, or b) all different. All of the features must separately satisfy this rule.").rulesP()
//                    }
//

                    
                    //
                    // Section: Examples
                    //
                    VStack(alignment: .leading) {
                        Text("Examples").rulesH1()
                        
                        Example(color1: .red, shape1: .oval, number1: .two, shading1: .open,
                                color2: .red, shape2: .oval, number2: .two, shading2: .striped,
                                color3: .red, shape3: .oval, number3: .two, shading3: .solid)
                        
                        Example(color1: .green, shape1: .squiggle, number1: .one, shading1: .striped,
                                color2: .purple, shape2: .oval, number2: .two, shading2: .striped,
                                color3: .red, shape3: .diamond, number3: .three, shading3: .striped)
                        
                        Example(color1: .purple, shape1: .oval, number1: .one, shading1: .striped,
                                color2: .green, shape2: .diamond, number2: .two, shading2: .solid,
                                color3: .red, shape3: .squiggle, number3: .three, shading3: .open)
                        
                    }
                    
                    
                    //
                    //
                    //

                }
                .padding(.horizontal, 22)
            }
        }
        .font(nil)
        .foregroundColor(UX.infoColor)
        .background(UX.backgroundColor)
    }
    
                                
}


struct RulesView_Previews: PreviewProvider {    
    static var previews: some View {
        RulesView()
    }
}

struct Example: View {
    
    let color1: SetGameModel.Card.ColorFeature
    let shape1: SetGameModel.Card.ShapeFeature
    let number1: SetGameModel.Card.NumberFeature
    let shading1: SetGameModel.Card.ShadingFeature

    let color2: SetGameModel.Card.ColorFeature
    let shape2: SetGameModel.Card.ShapeFeature
    let number2: SetGameModel.Card.NumberFeature
    let shading2: SetGameModel.Card.ShadingFeature

    let color3: SetGameModel.Card.ColorFeature
    let shape3: SetGameModel.Card.ShapeFeature
    let number3: SetGameModel.Card.NumberFeature
    let shading3: SetGameModel.Card.ShadingFeature
    
    var body: some View {
        VStack {
            HStack {
                RulesCardView(color: color1, number: number1, shape: shape1, shading: shading1)
                RulesCardView(color: color2, number: number2, shape: shape2, shading: shading2)
                RulesCardView(color: color3, number: number3, shape: shape3, shading: shading3)
            }
            VStack(spacing: 4) {
                showCheckFeature(featureName: "Color", checkResult: colorCheck)
                showCheckFeature(featureName: "Shape", checkResult: shapeCheck)
                showCheckFeature(featureName: "Number", checkResult: numberCheck)
                showCheckFeature(featureName: "Filling", checkResult: shadingCheck)
                showCheckFeature(featureName: "Result", checkResult: finalCheck)
            }.layoutPriority(1)
        }.rulesExampleBlock()
    }
    
    struct CheckResult {
        let isMatching: Bool
        let description: String
    }
    
    let maxName = "Number"
    
    func showCheckFeature(featureName: String, checkResult: CheckResult) -> some View {
        return HStack(alignment: .top, spacing: 6) {
            ZStack(alignment: .leading) {
                Text("\(featureName):     ").rulesExampleFeature()
                Text("\(maxName):     ").rulesExampleFeature().hidden()
            }
            Text(checkResult.isMatching ? "✅" : "❌").rulesExampleFeature()
            Text(checkResult.description).rulesExampleFeatureCheck()
        }
    }
    
    
    var colorCheck: CheckResult {
        checkFeature(f1: color1, f2: color2, f3: color3)
    }
    var shapeCheck: CheckResult {
        checkFeature(f1: shape1, f2: shape2, f3: shape3)
    }
    var numberCheck: CheckResult {
        checkFeature(f1: number1, f2: number2, f3: number3)
    }
    var shadingCheck: CheckResult {
        checkFeature(f1: shading1, f2: shading2, f3: shading3)
    }
    var finalCheck: CheckResult {
        if colorCheck.isMatching, shapeCheck.isMatching, numberCheck.isMatching, shadingCheck.isMatching {
            return CheckResult(isMatching: true, description: "This is Set.".uppercased())
        } else {
            return CheckResult(isMatching: false, description: "This is not Set.".uppercased())
        }
    }
    
    func checkFeature<T> (f1: T, f2: T, f3: T) -> CheckResult
    where T: Hashable, T: CustomStringConvertible {
        var organaiser: [T: Int] = [:]
        var searchResult: Int
        
        searchResult = organaiser[f1] ?? 0
        organaiser[f1] = searchResult + 1
        
        searchResult = organaiser[f2] ?? 0
        organaiser[f2] = searchResult + 1
        
        searchResult = organaiser[f3] ?? 0
        organaiser[f3] = searchResult + 1

        
        switch organaiser.count {
        case 1:
            return CheckResult(isMatching: true, description: "All the same")
        case 3:
            return CheckResult(isMatching: true, description: "All different")
        default:
            var description = [String]()
            for (feature, count) in organaiser {
                description.append((count==1 ? "One is " : "Two are ") + String(feature.description))
            }
            return CheckResult(isMatching: false, description: description.joined(separator: "\n"))
        }
    }
    
}
