//
//  ContentView.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 06.12.2020.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = SetGameViewModel()
    
    var body: some View {
        VStack {
            
            Button("New game") {
                newGame()
            }
            
            GridWithGap(viewModel.openedCards, aspectRatio: 1.5, gap: 11){ card in
                CardView(card: card)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)){
                            viewModel.choose(card: card)
                        }
                    }
                    .transition(
                        AnyTransition.asymmetric(
                            insertion: AnyTransition.offset(randomOffScreenOffset()),
                            removal: AnyTransition.offset(randomOffScreenOffset())
                        )
                    )
            }
            .layoutPriority(1)
            .onAppear{ newGame() }
            
            Spacer()
            
            
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    viewModel.deal3MoreCards()
                }
            } label : {
                
                VStack {
                    ZStack {
                        ForEach(viewModel.deckCards) { card in
                            CardView(card: card)
                                .frame(height: 44)
                        }
                    }
                    .padding(.bottom, 11)
                    
                    Text("Deal 3 more cards")
                }
            }
            .disabled(viewModel.isDeckEmpty)

        }
        .padding()
        
    }
    
    func newGame() {
        withAnimation(.easeInOut(duration: 0.5)) {
            viewModel.newGame()
        }
    }
    
    func randomOffScreenOffset() -> CGSize {
        let angle = Double.random(in: 0 ..< Double.pi * 2)
        let w = CGFloat(cos(angle)) * UIScreen.main.bounds.width * 2
        let h = CGFloat(sin(angle)) * UIScreen.main.bounds.height * 2
        return CGSize(width: w, height: h)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
