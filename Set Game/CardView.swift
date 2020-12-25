//
//  CardView.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 06.12.2020.
//

import SwiftUI

private let shapeWidthFactor: CGFloat = 0.21
private let cornerRadiusFactor: CGFloat = 1/12



struct CardView: View {
    let card: SetGameModel.Card
    var rotation: Double

    
    var isFaceUp: Bool {
        rotation < 90
    }

    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                
                // Face Up
                Group{
                    RoundedRectangle(cornerRadius: geometry.size.height * cornerRadiusFactor)
                        .foregroundColor(bgFromMatching(card.isMatched))
                    RoundedRectangle(cornerRadius: geometry.size.height * cornerRadiusFactor)
                        .stroke(Color.black.opacity(card.isSelected ? 1 : 0.25), lineWidth: card.isSelected ? 1.5 : 1)
                    CardFace(card: card)
                }
                .opacity(isFaceUp ? 1 : 0)
                
                // Cover
                Group{
                    RoundedRectangle(cornerRadius: geometry.size.height * cornerRadiusFactor)
                        .foregroundColor(Color.white)
                    RoundedRectangle(cornerRadius: geometry.size.height * cornerRadiusFactor)
                        .foregroundColor(Color.accentColor)
                        .opacity(0.66)
                        .padding(5)
                    RoundedRectangle(cornerRadius: geometry.size.height * cornerRadiusFactor)
                        .stroke(Color.accentColor.opacity(card.isSelected ? 1 : 1), lineWidth: card.isSelected ? 1.5 : 1)
                }
                .opacity(isFaceUp ? 0 : 1)
                
            }
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (-0.5, 0.5, 0))
        .aspectRatio(1.5, contentMode: .fit)

    }
    
    func bgFromMatching(_ isMatched: SetGameModel.Card.MatchingStatus) -> Color  {
        switch isMatched {
        case .inapplicable:
            return Color.white
        case .matched:
            return Color.green.opacity(0.1)
        case .notMatched:
            return Color.red.opacity(0.1)
        }
    }
    
}




struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
//                CardView(card: SetGameModel.Card(color: .green, number: .three, shape: .oval, shading: .open))
//                CardView(card: SetGameModel.Card(color: .green, number: .one, shape: .diamond, shading: .solid))
                CardView(card: SetGameModel.Card(color: .green, number: .one, shape: .diamond, shading: .solid), rotation: 0)
                CardView(card: SetGameModel.Card(color: .red, number: .three, shape: .diamond, shading: .solid), rotation: 0)
            }
            HStack(spacing: 16) {
//                CardView(card: SetGameModel.Card(color: .green, number: .three, shape: .squiggle, shading: .solid))
                CardView(card: SetGameModel.Card(color: .red, number: .three, shape: .diamond, shading: .solid), rotation: 0)
                CardView(card: SetGameModel.Card(color: .purple, number: .two, shape: .diamond, shading: .solid), rotation: 0)
                CardView(card: SetGameModel.Card(color: .red, number: .two, shape: .squiggle, shading: .solid), rotation: 1)
            }
            HStack(spacing: 16) {
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open), rotation: 0)
                CardView(card: SetGameModel.Card(color: .red, number: .three, shape: .diamond, shading: .solid), rotation: 0)
                CardView(card: SetGameModel.Card(color: .green, number: .three, shape: .oval, shading: .striped), rotation: 0)
                CardView(card: SetGameModel.Card(color: .red, number: .two, shape: .diamond, shading: .striped), rotation: 0)
            }
            HStack(spacing: 16) {
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open), rotation: 0)
                CardView(card: SetGameModel.Card(color: .purple, number: .one, shape: .diamond, shading: .open), rotation: 0)
                CardView(card: SetGameModel.Card(color: .green, number: .two, shape: .oval, shading: .striped), rotation: 0)
                CardView(card: SetGameModel.Card(color: .red, number: .two, shape: .diamond, shading: .striped), rotation: 0)
            }
            HStack(spacing: 16) {
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open), rotation: 0)
                CardView(card: SetGameModel.Card(color: .green, number: .three, shape: .oval, shading: .striped), rotation: 0)
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open), rotation: 0)
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open), rotation: 0)
            }
            HStack(spacing: 16) {
                CardView(card: SetGameModel.Card(color: .green, number: .three, shape: .oval, shading: .solid), rotation: 0)
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open), rotation: 0)
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open), rotation: 0)
                CardView(card: SetGameModel.Card(color: .purple, number: .two, shape: .diamond, shading: .solid), rotation: 0)
            }
        }
        .padding()
    }
}


