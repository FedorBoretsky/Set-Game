//
//  SetGameModel.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 06.12.2020.
//

import Foundation


class SetGameModel: ObservableObject {
    
    @Published var deck: [Card] = []
    @Published var openedCards: [Card] = []
    var flewAwayCards: [Card] = []
    
    let durationOfCheatModeInSeconds: Double = 3
    let durationOfPlayerMoveInSeconds: Double = 4
    static private let inactivityPenalty: Double = -1

    // MARK: - Initiation
    //
    //
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
    
    
    // MARK: - Checking
    //
    //
    
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
    
    
    private func isSet(_ indices: [Int]) -> Bool {
        if indices.count == 3 {
            return Self.isSet(openedCards[indices[0]], openedCards[indices[1]], openedCards[indices[2]])
        } else {
            return false
        }
    }
    
    
    /// Search and return all Sets in "face up" cards.
    /// - Returns: *[[ Card1, Card2, Card3], [Card4, Card5, Card6], …]* Two-dimesional array. Top level array consists of founded Sets. Each  Set is represented as array of three Cards.
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
    
    
    
    var isDeckEmpty: Bool {
        deck.isEmpty
    }


    var isGameOver = false
        
    private func updatePropertyIsGameOver() {
        // If there are some face-down cards we continue to play.
        if !isDeckEmpty {
            isGameOver = false
            return
        }
        
        // There are no face-down cards.
        // Check all Sets on the table
        for set in findSetsInOpenedCards() {
            for card in set {
                if card.isMatched != .matched {
                    // There is nonmatched Set on the table, so continue to play.
                    isGameOver = false
                    return
                }
            }
        }
        // There are no Sets on the table or all card in the Sets already matched: game over.
        isGameOver = true
        
    }

    
    // MARK: - Cheat Mode
    //
    //
    var isCheatMode: Bool = false
    {
        didSet {
            if isCheatMode {
                cheatModeDidSetOn()
            } else {
                cheatModeDidSetOff()
            }
        }
    }
    
    func cheatModeDidSetOn() {
        // Penalize cheating
        // TODO: Fix moving buttons when change sign. Try add one decimal penalty 0.3 without drifting buttons.
        changeScoreOfActivePlayer(by: -1)
        
        //
        // Prepare cheat info
        let sets¨ = findSetsInOpenedCards()
        let highlightedSet = sets¨.randomElement() ?? []
        for i in 0 ..< openedCards.count {
            openedCards[i].isCheatHighlight = highlightedSet.contains(openedCards[i])
        }
        //
        // Stop cheat mode after few seconds
        let stopCheatModeTimer = Timer(timeInterval: self.durationOfCheatModeInSeconds, repeats: false){_ in
            self.isCheatMode = false
        }
        RunLoop.current.add(stopCheatModeTimer, forMode: .common)
    }

    func cheatModeDidSetOff() {
        for i in openedCards.indices {
            openedCards[i].isCheatHighlight = false
        }
    }
    
    // MARK: - Players
    
    @Published var numberOfPlayers: Int = 1
    
    @Published var activePlayer: Int? = 0
    var isThereActivePlayer: Bool { activePlayer != nil }
    
    private var currentMove: UUID?
    
    
    func activatePlayer(_ playerIndex: Int) {
        
        // Player can't steal move from another player
        guard !isThereActivePlayer else {
            return
        }
        
        // Set player active
        activePlayer = playerIndex
        
        // Start new move
        currentMove = UUID()
        print("Activate player \(activePlayer!+1) with move \(currentMove!)")
        
        // Penalize the player after a few seconds if player does not make a move.
        let stopPlayerTimer = Timer(timeInterval: self.durationOfPlayerMoveInSeconds, repeats: false){_ in
            self.penalizeInactivity(duringMove: self.currentMove)
        }
        RunLoop.current.add(stopPlayerTimer, forMode: .common)

    }
    
    private func penalizeInactivity(duringMove moveWhenTimerStarted: UUID?) {
        if isThereActivePlayer && currentMove == moveWhenTimerStarted {
            changeScoreOfActivePlayer(by: Self.inactivityPenalty)
            finishMove()
        }
    }
    

    // MARK: - To Dos
    
    // TODO: Add guard protection from activePlayer == nil to all method where it needed.
    
    
    // MARK: - Score
    
    @Published private(set) var score: [Double] = [0]
    
    func changeScoreOfActivePlayer(by addition: Double) {
        if let playerIndex = activePlayer {
            score[playerIndex] += addition
        }
    }
    
    func finishMove() {
        if numberOfPlayers > 1 {
            // In multiplayer mode
            activePlayer = nil
            currentMove = nil
            // Treat selection
            if isSet(selectedIndices) {
                removeFoundedSet(selectedIndices)
            } else {
                for index in selectedIndices {
                    openedCards[index].isSelected = false
                    openedCards[index].isMatched = .inapplicable
                }
            }
        }
    }
    
    
    
    var selectedIndices: [Int] {
        openedCards.indices.filter{ openedCards[$0].isSelected }
    }
    
    
    
    
    
        
    // MARK: - Deal
    
    private func deal(numberOfCards: Int) {
        for _ in 0..<numberOfCards {
            if let card = deck.popLast() {
                openedCards.append(card)
            } else {
                break
            }
        }
//        openedCards += deck.suffix(numberOfCards)
//        if numberOfCards <= deck.count {
//            deck.removeLast(numberOfCards)
//        } else {
//            deck.removeAll()
//        }
        
        updatePropertyIsGameOver()
    }
    
    private func dealWithReplacing(indices: [Int]) {
        // TODO: Too complicated. Imply that deleting of cards already done outside this function.
        flyAway(indices)
        for index in indices.sorted(by: {$0 < $1}) {
            if let card = deck.popLast() {
                print (card)
                openedCards.insert(card, at: index)
            }
        }
        updatePropertyIsGameOver()
    }
    
    
    
    func intentOfPlayerDeals3Cards() {
        let selection = selectedIndices
        if isSet(selection) {
            //
            // Replace selected Set
            
            dealWithReplacing(indices: selection)
        } else {
            //
            // Add 3 more card
            
            // Penalize unnecessary dealing
            if !findSetsInOpenedCards().isEmpty {
                changeScoreOfActivePlayer(by: -1)
                finishMove()
            }
            
            // Add 3 cards
            deal(numberOfCards: 3)
        }
    }
    
    // MARK: -
    
    func flyAway(_ indices: [Int]) {
        for index in indices.sorted(by: {$0 > $1}) {
            openedCards.remove(at: index)
        }
    }
    
    // MARK: - Game
    
    func startGame(numberOfPlayers: Int) {
        
        isGameOver = false
        
        // Players and score setup
        self.numberOfPlayers = numberOfPlayers
        score = Array(repeating: 0, count: self.numberOfPlayers)
        if self.numberOfPlayers == 1 {
            activePlayer = 0
            currentMove = UUID()
        } else {
            activePlayer = nil
            currentMove = nil
        }
        
        // Cards setup
        deck = Self.fullDeck().shuffled() // TODO: Uncomment after finisn logic of showing GameOver
        deal(numberOfCards: 12)
    }
    
    func stopGame() {
        // TODO: Is stopGame() ever used? What the difference between stopGame() and cleanTable()?
        openedCards = []
    }
    
    /// Run the game with specific number of players.
    /// - Parameter numberOfPlayers: The number of players who will play.
    func newGame(numberOfPlayers: Int) {
        stopGame()
        startGame(numberOfPlayers: numberOfPlayers)
    }
    
    /// Restart a game with the same number of players as the previous game.
    func newGame() {
        newGame(numberOfPlayers: self.numberOfPlayers)
    }

    func cleanTable() {
        // TODO: Is cleanTable() ever used? What the difference between stopGame() and cleanTable()?
        openedCards = []
    }
    
    fileprivate func removeFoundedSet(_ previousSelection: [Int]) {
        if openedCards.count == 12 {
            dealWithReplacing(indices: previousSelection)
        } else {
            flyAway(previousSelection)
        }
    }
    
    func choose(card: Card) {
        
        // Don't choose without activated player
        guard isThereActivePlayer else {
            return
        }
        
        // TODO: What this guard do? Is it real situation when Card not in openedCards
        guard let choosenCardIndex = openedCards.firstIndex(matching: card) else {
            return
        }
        
        //
        //
        //
        
        let previousSelection = selectedIndices
        
        if previousSelection.count < 3 {
            openedCards[choosenCardIndex].isSelected.toggle()
        } else {
            // 3 cards was selected
            if isSet(previousSelection) {
                // Select card if it outside Set
                if !previousSelection.contains(choosenCardIndex) {
                    openedCards[choosenCardIndex].isSelected = true
                }
                removeFoundedSet(previousSelection)
            } else {
                for index in previousSelection {
                    openedCards[index].isSelected = false
                    openedCards[index].isMatched = .inapplicable
                }
                openedCards[choosenCardIndex].isSelected = true
            }
        }
        
        //
        //
        //
        
        let newSelection = selectedIndices
        
        if newSelection.count == 3 {
            let isMatched = isSet(newSelection)
            for i in newSelection {
                openedCards[i].isMatched = isMatched ? .matched : .notMatched
            }
            changeScoreOfActivePlayer(by: isMatched ? +1 : -1)
            // TODO: In multiplayer mode hide founded Set without waiting next move but show matched/notMatched animation
            finishMove()
        }
        
        updatePropertyIsGameOver()
        
    }


    
    struct Card: Identifiable, Equatable {
        let color: ColorFeature
        let number: NumberFeature
        let shape: ShapeFeature
        let shading: ShadingFeature
        var id: String {
            get {
                [
                    String(number.description),
                    String(color.description),
                    String(shading.description),
                    String(shape.description)
                ].joined(separator: "_")
            }
        }
                
        enum ColorFeature: String, CaseIterable, CustomStringConvertible {
            case red
            case green
            case purple
            //
            var description: String { self.rawValue }
        }
        enum NumberFeature: Int, CaseIterable, CustomStringConvertible {
            case one = 1
            case two = 2
            case three = 3
            //
            var description: String { String(self.rawValue) }
        }
        enum ShapeFeature: String, CaseIterable, CustomStringConvertible {
            case diamond
            case squiggle
            case oval
            //
            var description: String { self.rawValue }
        }
        enum ShadingFeature: String, CaseIterable, CustomStringConvertible {
            case solid
            case striped
            case open
            //
            var description: String { self.rawValue }
        }
        
        
        var isSelected: Bool = false
        
        var isMatched: MatchingStatus = .inapplicable  // TODO: Rename variable. Name "isMatched" give incorrect sense of type. This variable is not Bool.
        enum MatchingStatus {
            case inapplicable
            case matched
            case notMatched
        }
        
        var isCheatHighlight: Bool = false
        
        
    }
    
}

#if DEBUG
let testCardArray = [
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
    
    ///
    ///
    ///
    
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
