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
            .padding()
            
            Grid(viewModel.openedCards, desiredAspectRatio: 1.5){ card in
                CardView(card: card)
                    .onTapGesture {
                        withAnimation{
                            viewModel.choose(card: card)
                        }
                    }
                    .transition(AnyTransition.asymmetric(
                                    insertion: .move(edge: .bottom),
                                    removal: .scale))

                    .padding(4)
            }
            .padding()
            .onAppear{ newGame() }
            
            Spacer()
            
            
            Button("Deal 3 more cards") {
                withAnimation(.easeInOut(duration: 0.5)) {
                    viewModel.deal3MoreCards()
                }
            }
            .disabled(viewModel.isDeckEmpty)
            .padding()

        }
        
    }
    
    func newGame() {
        withAnimation(.easeInOut(duration: 0.5)) {
            viewModel.newGame()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
