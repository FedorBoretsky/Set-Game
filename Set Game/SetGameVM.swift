//
//  SetGameVM.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 12.12.2020.
//

import SwiftUI
import Combine

class SetGameViewModel: ObservableObject {
    
    @Published private var model: SetGameModel = SetGameModel()
    
    private var sub: AnyCancellable?
    
    init() {
        sub = model.objectWillChange.sink{ self.objectWillChange.send() }
    }
    
    
    // MARK: - Access to the Model's data
    
    var openedCards: [SetGameModel.Card] {
        model.openedCards
    }
    
    var deckCards: [SetGameModel.Card] {
        model.deck
    }

    var score: Double {
        model.score
    }
    
    var isDeckEmpty: Bool {
        model.isDeckEmpty
    }
    
    var isCheatMode: Bool {
        model.cheatMode
    }
    
    // MARK: - Intents
    
    func newGame() {
//        model = SetGameModel()
//        model.cleanTable()
//        model.startGame()
        model.newGame()
    }
    
    func deal3MoreCards() {
        model.deal3MoreCards()
    }
    
    func choose(card: SetGameModel.Card) {
        model.choose(card: card)
    }
    
    func cheatModeOn() {
        return model.cheatMode = true
    }

    func cheatModeOff() {
        return model.cheatMode = false
    }
}
