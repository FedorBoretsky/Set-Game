//
//  SetGameModel.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 06.12.2020.
//

import Foundation

struct SetGameModel {
    
    static func fullDeck() -> [Card] {
        var deck = [Card]()
        for color in ColorFeature.allCases {
            for number in NumberFeature.allCases {
                for shape in ShapeFeature.allCases {
                    for shading in ShadingFeature.allCases {
                        deck.append(
                            Card(color: color,
                                 number: number,
                                 shape: shape,
                                 shading: shading)
                        )
                    }
                }
            }
        }
        return deck
    }
    
    
    static func isSet (_ Card1: Card, _ Card2: Card, _ Card3: Card) -> Bool {
        func allTheSame<Feature> (_ First: Feature, _ Second: Feature, _ Third: Feature) -> Bool
        where Feature: Equatable
        {
            return (First == Second) && (Second == Third)
        }
        
        func allDifferent<Feature> (_ First: Feature, _ Second: Feature, _ Third: Feature) -> Bool
        where Feature: Equatable
        {
            return (First != Second) && (Second != Third) && (Third != First)
        }
        
        func isFeatereSet<Feature> (_ First: Feature, _ Second: Feature, _ Third: Feature) -> Bool
        where Feature: Equatable
        {
            return allTheSame(First, Second, Third) || allDifferent(First, Second, Third)
        }
        
        return isFeatereSet(Card1.color,   Card2.color,   Card3.color) &&
               isFeatereSet(Card1.number,  Card2.number,  Card3.number) &&
               isFeatereSet(Card1.shape,   Card2.shape,   Card3.shape) &&
               isFeatereSet(Card1.shading, Card2.shading, Card3.shading)
    }
    
    enum ColorFeature: CaseIterable {
        case red
        case green
        case purple
    }
    
    enum NumberFeature: CaseIterable {
        case one
        case two
        case three
    }
    
    enum ShapeFeature: CaseIterable {
        case diamond
        case squiggle
        case oval
    }
    
    enum ShadingFeature: CaseIterable {
        case solid
        case striped
        case open
    }
    
    struct Card {
        let color: ColorFeature
        let number: NumberFeature
        let shape: ShapeFeature
        let shading: ShadingFeature
    }
    
}

#if DEBUG
let testData = [
    SetGameModel.Card(color: .green, number: .one, shape: .diamond, shading: .striped),

    SetGameModel.Card(color: .red, number: .one, shape: .diamond, shading: .striped),
    SetGameModel.Card(color: .red, number: .two, shape: .diamond, shading: .solid),
    SetGameModel.Card(color: .red, number: .three, shape: .diamond, shading: .open),
    
    SetGameModel.Card(color: .red, number: .two, shape: .oval, shading: .open),
    SetGameModel.Card(color: .red, number: .two, shape: .oval, shading: .striped),
    SetGameModel.Card(color: .red, number: .two, shape: .oval, shading: .solid),
    
    SetGameModel.Card(color: .green, number: .one, shape: .squiggle, shading: .striped),
    SetGameModel.Card(color: .purple, number: .two, shape: .oval, shading: .striped),
    SetGameModel.Card(color: .red, number: .three, shape: .diamond, shading: .striped),
    
    SetGameModel.Card(color: .purple, number: .one, shape: .oval, shading: .striped),
    SetGameModel.Card(color: .green, number: .two, shape: .diamond, shading: .solid),
    SetGameModel.Card(color: .red, number: .three, shape: .squiggle, shading: .open),
]
#endif
