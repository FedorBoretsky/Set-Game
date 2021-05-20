//
//  CardView.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 06.12.2020.
//

import SwiftUI




struct CardView: View {
    let card: SetGameModel.Card
    var rotation: Double
//    var isInsideRules: Bool?

    
    var isFaceUp: Bool {
        rotation < 90
    }

    private let shapeWidthFactor: CGFloat = 0.21
    private let cornerRadiusFactor: CGFloat = 8/118
    private let coverImagePaddingFactor: CGFloat = 10/118
    private let coverImageRadiusFactor: CGFloat = 5/118

    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                
                // Face Up
                Group{
                    // Card area
                    RoundedRectangle(cornerRadius: geometry.size.height * cornerRadiusFactor)
                        .foregroundColor(bgFromMatching(card.isMatched))
                        .animation(nil)
                    // Highlight for selected card
                    if card.isSelected {
                        RoundedRectangle(cornerRadius: geometry.size.height * cornerRadiusFactor + 2)
                            .stroke(Color.yellow, lineWidth: 3)
                            .offset(CGSize(width: -3, height: -3))
                            .frame(width: geometry.size.width+6, height: geometry.size.height+6)
                            .transition(.identity)
                    }
                    // Face Image
                    CardFace(card: card)
                }
                .opacity(isFaceUp ? 1 : 0)
                
                // Cover
                Group{
                    // Card area
                    RoundedRectangle(cornerRadius: geometry.size.height * cornerRadiusFactor)
                        .foregroundColor(Color.white)
                    // Cover pattern
                    RoundedRectangle(cornerRadius: geometry.size.height * coverImageRadiusFactor)
                        .foregroundColor(UX.cardCoverPatternColor)
                        .padding(geometry.size.height * coverImagePaddingFactor)
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
            return Color.yellow
        case .notMatched:
            return Color.init(white: 0.8)
        }
    }
    
    func selectionColorFromMatching(_ isMatched: SetGameModel.Card.MatchingStatus) -> Color  {
        switch isMatched {
        case .inapplicable:
            return Color.clear
        case .matched:
            return Color.yellow
        case .notMatched:
            return Color.init(white: 0.8)
        }
    }
    
}




struct CardView_Previews: PreviewProvider {
    
    static let gap: CGFloat = 10
    
    static var previews: some View {
        
        
        ZStack {
            UX.backgroundColor
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: gap) {
                HStack(spacing: gap) {
                    CardView(card: SetGameModel.Card(color: .green, number: .one, shape: .diamond, shading: .solid), rotation: 0)
                    CardView(card: SetGameModel.Card(color: .red, number: .three, shape: .diamond, shading: .solid), rotation: 0)
                }
                HStack(spacing: gap) {
                    CardView(card: SetGameModel.Card(color: .red, number: .three, shape: .diamond, shading: .solid), rotation: 0)
                    CardView(card: SetGameModel.Card(color: .purple, number: .two, shape: .diamond, shading: .solid), rotation: 0)
                    CardView(card: SetGameModel.Card(color: .red, number: .two, shape: .squiggle, shading: .solid), rotation: 1)
                }
                HStack(spacing: gap) {
                    CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open), rotation: 0)
                    CardView(card: SetGameModel.Card(color: .green, number: .two, shape: .diamond, shading: .open), rotation: 0)
                    CardView(card: SetGameModel.Card(color: .red, number: .three, shape: .squiggle, shading: .striped), rotation: 0)
                    CardView(card: SetGameModel.Card(color: .red, number: .two, shape: .diamond, shading: .striped), rotation: 0)
                }
                HStack(spacing: gap) {
                    CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .solid), rotation: 0)
                    CardView(card: SetGameModel.Card(color: .red, number: .three, shape: .squiggle, shading: .solid), rotation: 0)
                    CardView(card: SetGameModel.Card(color: .green, number: .one, shape: .oval, shading: .striped), rotation: 0)
                    CardView(card: SetGameModel.Card(color: .red, number: .two, shape: .diamond, shading: .striped), rotation: 0)
                }
                HStack(spacing: gap) {
                    CardView(card: SetGameModel.Card(color: .red, number: .two, shape: .diamond, shading: .solid), rotation: 0)
                    CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .oval, shading: .open), rotation: 0)
                    CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .oval, shading: .solid), rotation: 0)
                    CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open), rotation: 0)
                }
                HStack(spacing: gap) {
                    CardView(card: SetGameModel.Card(color: .green, number: .one, shape: .oval, shading: .solid), rotation: 0)
                    CardView(card: SetGameModel.Card(color: .purple, number: .one, shape: .oval, shading: .open), rotation: 0)
                    CardView(card: SetGameModel.Card(color: .red, number: .two, shape: .diamond, shading: .striped), rotation: 0)
                    CardView(card: SetGameModel.Card(color: .purple, number: .two, shape: .diamond, shading: .solid), rotation: 0)
                }
            }
            .padding()
        }
    }
}


