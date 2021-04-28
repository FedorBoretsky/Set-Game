//
//  DeckView.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 07.04.2021.
//

import SwiftUI

struct DeckView: View {
    
    let deckCards: [SetGameModel.Card]
    @Environment(\.isEnabled) var isEnabled

    
    var body: some View {
        ZStack {
            ForEach(0..<deckCards.count, id: \.self) { i in
                CardView(card: deckCards[i], rotation: 180)
                    .frame(height: 66)
                    .rotationEffect(rotationForIndex(i))
                    .offset(offsetForIndex(i))
                    .shadow(color: Color/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity( isShadowForIndex(i) ? 0.3 : 0), radius: 2, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                    .background(MyPreferenceViewSetter(id: "deck"))
            }
            // Disabled
            if !isEnabled {
                Rectangle()
                    .foregroundColor(UX.backgroundColor)
                    .opacity(0.8)
            }
        }
        .frame(width: 116, height: 116)
    }
    
    
    func rotationForIndex(_ index: Int) -> Angle {        
        switch deckCards.count - index {
        // Three top cards are fanned out
        case 1:
            return Angle(degrees: 7)
        case 2:
            return Angle(degrees: 0)
        case 3:
            return Angle(degrees: -8)
        // Other cards are stacked
        default:
            return Angle(degrees: -8)
        }
    }
    

    func offsetForIndex(_ index: Int) -> CGSize {
        let xOffsetFor3 = -6.3
        let yOffsetFor3 = -0.25
        let xOffsetFor9 = -13.1
        let yOffsetFor9 = 1.05
        let dx = (xOffsetFor9 - xOffsetFor3) / 6
        let dy = (yOffsetFor9 - yOffsetFor3) / 6

        
        switch deckCards.count - index {
        // Three top cards are fanned out
        case 1:
            return CGSize(width: 14.7, height: -1.5)
        case 2:
            return CGSize(width: 3.7, height: -1)
        case 3:
            return CGSize(width: xOffsetFor3, height: yOffsetFor3)
        // Cards from 4 to 9 stacked with small shift
        case let n where (4...9).contains(n):
            return CGSize(width: xOffsetFor3 + Double(n - 3) * dx,
                          height: yOffsetFor3 + Double(n - 3) * dy)
        // Other cards are strictly stacked
        default:
            return CGSize(width: xOffsetFor9, height: yOffsetFor9)
        }
    }
    
    func isShadowForIndex(_ index: Int) -> Bool {
        switch deckCards.count - index {
        // Show shadow only for directly visible cards
        // to avoid too dark cumulative shadows of the deck.
        case 1...9:
            return true
        default:
            return false
        }
    }
    
    

}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            UX.backgroundColor
                .ignoresSafeArea(.all)
            VStack(spacing: 50) {
                Image("Deck Copy")
                    .resizable()
                    .frame(width: 225/2, height: 230/2)
                DeckView(deckCards: testCardArray)
                    .disabled(true)
            }
        }
    }
}
