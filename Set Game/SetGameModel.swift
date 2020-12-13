//
//  SetGameModel.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 06.12.2020.
//

import Foundation

struct SetGameModel {
    
    private var deck: [Card] = Self.fullDeck().shuffled()
    var openedCards: [Card] = []
    var flewAwayCards: [Card] = []
    var selectedIndices: [Int] {
        openedCards.indices.filter{ openedCards[$0].isSelected }
    }

    var isDeckEmpty: Bool {
        get { deck.isEmpty }
    }
    
    
    static func fullDeck() -> [Card] {
        var deck = [Card]()
        for color in Card.ColorFeature.allCases {
            for number in Card.NumberFeature.allCases {
                for shape in Card.ShapeFeature.allCases {
                    for shading in Card.ShadingFeature.allCases {
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
        
        func isFeatureMakeUpSet<Feature> (_ First: Feature, _ Second: Feature, _ Third: Feature) -> Bool
        where Feature: Equatable {
            
            func allTheSame (_ First: Feature, _ Second: Feature, _ Third: Feature) -> Bool {
                return (First == Second) && (Second == Third)
            }
            
            func allDifferent (_ First: Feature, _ Second: Feature, _ Third: Feature) -> Bool {
                return (First != Second) && (Second != Third) && (Third != First)
            }
            
            return allTheSame(First, Second, Third) || allDifferent(First, Second, Third)
        }
        
        return isFeatureMakeUpSet(Card1.color,   Card2.color,   Card3.color) &&
               isFeatureMakeUpSet(Card1.number,  Card2.number,  Card3.number) &&
               isFeatureMakeUpSet(Card1.shape,   Card2.shape,   Card3.shape) &&
               isFeatureMakeUpSet(Card1.shading, Card2.shading, Card3.shading)
    }
    
    private func isSet(_ i1: Int, _ i2: Int, _ i3: Int) -> Bool {
        return Self.isSet(openedCards[i1], openedCards[i2], openedCards[i3])
    }
    
    private func isSet(_ indices: [Int]) -> Bool {
        if indices.count == 3 {
            return isSet(indices[0], indices[1], indices[2])
        } else {
            return false
        }
    }
    
    mutating func deal(numberOfCards: Int) {
        openedCards += deck.suffix(numberOfCards)
        if numberOfCards <= deck.count {
            deck.removeLast(numberOfCards)
        } else {
            deck.removeAll()
        }
    }
    
    private mutating func flyAway(_ indices: [Int]) {
        for index in indices.sorted(by: {$0 > $1}) {
            openedCards.remove(at: index)
        }
    }
    
    mutating func choose(card: Card) {
        guard let choosenIndex = openedCards.firstIndex(matching: card) else {
            return
        }
        
        let previousSelection = selectedIndices
        
        if previousSelection.count < 3 {
            openedCards[choosenIndex].isSelected.toggle()
        } else {
            if !previousSelection.contains(choosenIndex) {
                openedCards[choosenIndex].isSelected = true
            }
            if isSet(previousSelection) {
                flyAway(previousSelection)
            } else {
                for index in previousSelection {
                    openedCards[index].isSelected = false
                    openedCards[index].isMatched = .inapplicable
                }
            }
            
        }
        
        let newSelection = selectedIndices
        
        if newSelection.count == 3 {
            let isMatched = isSet(newSelection)
            for i in newSelection {
                openedCards[i].isMatched = isMatched ? .matched : .notMatched
            }
        }
        
        
    }


    
    struct Card: Identifiable {
        let color: ColorFeature
        let number: NumberFeature
        let shape: ShapeFeature
        let shading: ShadingFeature
        var id: String {
            get {
                [String (number.rawValue),
                 String(color.rawValue),
                 String(shading.rawValue),
                 String(shape.rawValue)
                ].joined(separator: "_")
            }
        }
        
        enum ColorFeature: String, CaseIterable {
            case red
            case green
            case purple
        }
        enum NumberFeature: Int, CaseIterable {
            case one = 1
            case two = 2
            case three = 3
        }
        enum ShapeFeature: String, CaseIterable {
            case diamond
            case squiggle
            case oval
        }
        enum ShadingFeature: String, CaseIterable {
            case solid
            case striped
            case open
        }
        
        
        var isSelected: Bool = false
        var isMatched: MatchingStatus = .inapplicable
        
        enum MatchingStatus {
            case inapplicable
            case matched
            case notMatched
        }
        
        
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
