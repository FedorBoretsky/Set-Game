//
//  RulesCardView.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 24.04.2021.
//

import SwiftUI

struct RulesCardView: View {
    let color: SetGameModel.Card.ColorFeature
    let number: SetGameModel.Card.NumberFeature
    let shape: SetGameModel.Card.ShapeFeature
    let shading: SetGameModel.Card.ShadingFeature
    
    var body: some View {
//        ZStack {
            CardView(card: SetGameModel.Card(
                        color: color,
                        number: number,
                        shape: shape,
                        shading: shading), rotation: 0) //, isInsideRules: true)
            
//            RoundedRectangle(cornerRadius: geometry.size.height * CardView.cornerRadiusFactor)
//            .stroke()

//            .clipped()
//            .shadow(color: .init(white: 0.25), radius: 1, x: 0.25, y: 0.25)
//        }
    }
}

struct RulesCardView_Previews: PreviewProvider {
    static var previews: some View {
        RulesCardView(color: .red,
                      number: .two,
                      shape: .diamond,
                      shading: .solid)
            .padding()
    }
}
