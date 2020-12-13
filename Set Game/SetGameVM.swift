//
//  SetGameVM.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 12.12.2020.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    
    @Published private var model: SetGameModel = SetGameModel()
    
    
    // MARK: - Access to the Model
    
    var openedCards: [SetGameModel.Card] {
        model.openedCards
    }
    
    var isDeckEmpty: Bool {
        model.isDeckEmpty
    }
    
    // MARK: - Intents
    
    func newGame() {
        model = SetGameModel()
        model.deal(numberOfCards: 12)
    }
    
    func deal3MoreCards() {
        model.deal(numberOfCards: 3)
    }
    
    func choose(card: SetGameModel.Card) {
        model.choose(card: card)
    }
}
