//
//  SetGameModel.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 06.12.2020.
//

import Foundation


struct SetGameModel {
    
    var deck: [Card] = []
    var openedCards: [Card] = []
    var flewAwayCards: [Card] = []
    
    static private let fewSeconds: Double = 4
    
    
    // MARK: - Cheat Mode
    //
    //
    var cheatMode: Bool = false
    {
        didSet {
            if cheatMode {
                score -= 0.25
                //
                // Prepare cheat info
                let sets¨ = findSetsInOpenedCards()
                let highlightedSet = sets¨.randomElement() ?? []
                for i in 0 ..< openedCards.count {
                    openedCards[i].isCheatHighlight = highlightedSet.contains(openedCards[i])
                }
                //
                // Stop after few seconds
                let stopCheatTimer = Timer(timeInterval: Self.fewSeconds, repeats: false){ [unowned self] _ in
                    cheatMode = false
                }
                RunLoop.current.add(stopCheatTimer, forMode: .common)
            } else {
                cheatModeOff()
            }
        }
    }
    
//    mutating func cheatModeOn() {
//        score -= 0.25
//        //
//        // Prepare cheat info
//        let sets¨ = findSetsInOpenedCards()
//        let highlightedSet = sets¨.randomElement() ?? []
//        for i in 0 ..< openedCards.count {
//            openedCards[i].isCheatHighlight = highlightedSet.contains(openedCards[i])
//        }
//        //
//        // Stop after few seconds
//        let stopCheatTimer = Timer(timeInterval: Self.fewSeconds, repeats: false){_ in
//            cheatMode = false
//        }
//        RunLoop.current.add(stopCheatTimer, forMode: .common)
//    }

    mutating func cheatModeOff() {
        for i in 0 ..< openedCards.count {
            openedCards[i].isCheatHighlight = false
        }
    }

    
    
    var isThereNoSetInOpenedCards: Bool {
        return findSetsInOpenedCards().isEmpty
    }
    
    private(set) var score: Double = 0
    
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
    
//    private func isSet(_ i1: Int, _ i2: Int, _ i3: Int) -> Bool {
//        return Self.isSet(openedCards[i1], openedCards[i2], openedCards[i3])
//    }
    
    private func isSet(_ indices: [Int]) -> Bool {
        if indices.count == 3 {
            return Self.isSet(openedCards[indices[0]], openedCards[indices[1]], openedCards[indices[2]])
        } else {
            return false
        }
    }
    
    
    private func findSetsInOpenedCards() -> [[Card]] {
        var sets¨: [[Card]] = []
        for i1 in 0 ..< openedCards.count {
            for i2 in (i1 + 1) ..< openedCards.count {
                for i3 in (i2 + 1) ..< openedCards.count {
                    if Self.isSet(openedCards[i1], openedCards[i2], openedCards[i3]) {
                        sets¨.append([openedCards[i1], openedCards[i2], openedCards[i3]])
                    }
                }
            }
        }
        return sets¨
    }
        
    
    mutating func deal(numberOfCards: Int) {
        openedCards += deck.suffix(numberOfCards)
        if numberOfCards <= deck.count {
            deck.removeLast(numberOfCards)
        } else {
            deck.removeAll()
        }
    }
    
    mutating func dealWithReplacing(indices: [Int]) {
        for index in indices.sorted(by: {$0 < $1}) {
            if let card = deck.popLast() {
                openedCards.insert(card, at: index)
            }
        }
    }
    
    
    
    mutating func deal3MoreCards() {
        let selection = selectedIndices
        if isSet(selection) {
            flyAway(selection)
            dealWithReplacing(indices: selection)
        } else {
            deal(numberOfCards: 3)
            score -= 1
        }
    }
    
    
    private mutating func flyAway(_ indices: [Int]) {
        for index in indices.sorted(by: {$0 > $1}) {
            openedCards.remove(at: index)
        }
    }
    
    mutating func startGame() {
        deck = Self.fullDeck().shuffled()
        score = 0
        deal(numberOfCards: 12)
    }
    
    mutating func stopGame() {
        openedCards = []
    }
    
    mutating func newGame() {
        stopGame()
        startGame()
    }

    
    mutating func cleanTable() {
        openedCards = []
    }
    
    mutating func choose(card: Card) {
        guard let choosenIndex = openedCards.firstIndex(matching: card) else {
            return
        }
        
        //
        //
        //
        
        let previousSelection = selectedIndices
        
        if previousSelection.count < 3 {
            openedCards[choosenIndex].isSelected.toggle()
        } else {
            // 3 cards was selected
            if isSet(previousSelection) {
                if !previousSelection.contains(choosenIndex) {
                    openedCards[choosenIndex].isSelected = true
                }
                flyAway(previousSelection)
                if openedCards.count < 12 {
                    dealWithReplacing(indices: previousSelection)
                }
            } else {
                for index in previousSelection {
                    openedCards[index].isSelected = false
                    openedCards[index].isMatched = .inapplicable
                    openedCards[choosenIndex].isSelected = true
                }
            }
            
        }
        
        //
        //
        //
        
        let newSelection = selectedIndices
        
        if newSelection.count == 3 {
            let isMatched = isSet(newSelection)
            if isMatched {
                score += 1
            } else {
                score -= 1
            }
            for i in newSelection {
                openedCards[i].isMatched = isMatched ? .matched : .notMatched
            }
        }
        
        
    }


    
    struct Card: Identifiable, Equatable {
        let color: ColorFeature
        let number: NumberFeature
        let shape: ShapeFeature
        let shading: ShadingFeature
        var id: String {
            get {
                [
                    String (number.rawValue),
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
        
        var isCheatHighlight: Bool = false
        
        
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
