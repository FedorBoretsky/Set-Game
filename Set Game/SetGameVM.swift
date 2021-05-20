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
    
    var isDeckEmpty: Bool {
        model.isDeckEmpty
    }
    
    var isCheatMode: Bool {
        model.isCheatMode
    }
    
    var numberOfPlayers: Int {
        model.numberOfPlayers
    }
    
    func scoreOfPlayer(_ playerIndex: Int) -> Double {
        model.score[playerIndex]
    }
    
    var activePlayerIndex: Int? {
        model.activePlayer
    }
    
    var isThereActivePlayer: Bool {
        model.isThereActivePlayer
    }
    
    var durationOfCheatModeInSeconds: Double {
        model.durationOfCheatModeInSeconds
    }
    
    var durationOfPlayerMoveInSeconds: Double {
        model.durationOfPlayerMoveInSeconds
    }

    
    // MARK: - Checking
    
    var isGameOver: Bool {
        model.isGameOver
    }
    
    
    // MARK: - Intents
    
    func newGame() {
        model.newGame()
    }
    
    func newSinglePlayerGame() {
        model.newGame(numberOfPlayers: 1)
    }
    
    func newTwoPlayerGame() {
        model.newGame(numberOfPlayers: 2)
    }
    
    func activatePlayer(_ playerIndex: Int) {
        model.activatePlayer(playerIndex)
    }
    
    func deal3Cards() {
        model.intentOfPlayerDeals3Cards()
    }
    
    func choose(card: SetGameModel.Card) {
        model.choose(card: card)
    }
    
    func cheatModeOn() {
        return model.isCheatMode = true
    }

    func cheatModeOff() {
        return model.isCheatMode = false
    }
}
