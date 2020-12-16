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
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: geometry.size.height * cornerRadiusFactor)
                    .foregroundColor(bgFromMatching(card.isMatched))
                RoundedRectangle(cornerRadius: geometry.size.height * cornerRadiusFactor)
                    .stroke(Color.black.opacity(card.isSelected ? 1 : 0.25), lineWidth: card.isSelected ? 1.5 : 1)
//                    .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 0)
                
                CardFace(card: card)

            }
        }
        .aspectRatio(1.5, contentMode: .fit)

    }
    
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
//                CardView(card: SetGameModel.Card(color: .green, number: .three, shape: .oval, shading: .open))
//                CardView(card: SetGameModel.Card(color: .green, number: .one, shape: .diamond, shading: .solid))
                CardView(card: SetGameModel.Card(color: .green, number: .one, shape: .diamond, shading: .solid))
                CardView(card: SetGameModel.Card(color: .red, number: .three, shape: .diamond, shading: .solid))
            }
            HStack(spacing: 16) {
//                CardView(card: SetGameModel.Card(color: .green, number: .three, shape: .squiggle, shading: .solid))
                CardView(card: SetGameModel.Card(color: .red, number: .three, shape: .diamond, shading: .solid))
                CardView(card: SetGameModel.Card(color: .purple, number: .two, shape: .diamond, shading: .solid))
                CardView(card: SetGameModel.Card(color: .red, number: .two, shape: .squiggle, shading: .solid))
            }
            HStack(spacing: 16) {
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open))
                CardView(card: SetGameModel.Card(color: .red, number: .three, shape: .diamond, shading: .solid))
                CardView(card: SetGameModel.Card(color: .green, number: .three, shape: .oval, shading: .striped))
                CardView(card: SetGameModel.Card(color: .red, number: .two, shape: .diamond, shading: .striped))
            }
            HStack(spacing: 16) {
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open))
                CardView(card: SetGameModel.Card(color: .purple, number: .one, shape: .diamond, shading: .open))
                CardView(card: SetGameModel.Card(color: .green, number: .two, shape: .oval, shading: .striped))
                CardView(card: SetGameModel.Card(color: .red, number: .two, shape: .diamond, shading: .striped))
            }
            HStack(spacing: 16) {
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open))
                CardView(card: SetGameModel.Card(color: .green, number: .three, shape: .oval, shading: .striped))
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open))
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open))
            }
            HStack(spacing: 16) {
                CardView(card: SetGameModel.Card(color: .green, number: .three, shape: .oval, shading: .solid))
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open))
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open))
                CardView(card: SetGameModel.Card(color: .purple, number: .two, shape: .diamond, shading: .solid))
            }
        }
        .padding()
    }
}


