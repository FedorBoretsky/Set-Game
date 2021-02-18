//
//  ContentView.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 06.12.2020.
//

import SwiftUI

// TODO: Need explanation

let scoreFrameSize: CGFloat = 66

// TODO: - Need explanation
struct DealingAdjustment {
    let offset: CGSize
    let scale: CGSize
    let rotation: Double
    
    static var noDeviation: DealingAdjustment {
        DealingAdjustment(
            offset: CGSize.zero,
            scale: CGSize(width: 1, height: 1),
            rotation: 0
        )
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = SetGameViewModel()
    
    // TODO: Need explanation
    @State private var storedRects¨: [String: CGRect] = Dictionary()
    @State private var dealingAdjustments¨: [String: DealingAdjustment] = Dictionary()
    
    var body: some View {
        VStack {
            
            // Header
            HStack(alignment: .firstTextBaseline) {
                Text("Set game")
                    .font(.largeTitle)
                Spacer()
                Button("New game") {
                    newGame()
                }
            }
            
            // Opened cards
            GridWithGap(viewModel.openedCards, aspectRatio: 1.5, gap: 11){ card in
                CardView(card: card, rotation: dealingAdjustments¨[card.id, default: .noDeviation].rotation)
                    .background(MyPreferenceViewSetter(id: card.id))
                    .transition(
                        AnyTransition.asymmetric(
                            insertion: AnyTransition.identity,
                            removal: AnyTransition.offset(randomOffScreenOffset())
                        )
                    )
                    .opacity( viewModel.isCheatMode ? (card.isCheatHighlight ? 1 : 0) : 1)
                    // Apply scale card first to avoid scaling other geometries.
                    .scaleEffect(dealingAdjustments¨[card.id, default: .noDeviation].scale, anchor: .topLeading)
                    .offset(dealingAdjustments¨[card.id, default: .noDeviation].offset)
                    .onAppear{ startDealingAnimation(for: card) }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)){
                            viewModel.choose(card: card)
                        }
                    }

            }
            .zIndex(1)
            .onAppear{ newGame() }
            
            Spacer()
            
            HStack(alignment: .top){
                
                // Score
                VStack(alignment: .leading){
                    Text("Score:")
                    Text("\(viewModel.score, specifier: "%g")")
                            .font(Font.system(size: scoreFrameSize, weight: .thin))

                }
                .animation(.none)
                Spacer()
                
                // Deck
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewModel.deal3MoreCards()
                    }
                } label : {
                    
                    VStack {
                        Text("Deal 3 more cards")
                        ZStack {
                            ForEach(viewModel.deckCards) { card in
                                CardView(card: card, rotation: 180)
                                    .frame(height: 44)
                                    .background(MyPreferenceViewSetter(id: "deck"))
                            }
                        }
                        .frame(width: 66, height: 66, alignment: .center)
                        
                    }
                }
                .disabled(viewModel.isDeckEmpty)
                Spacer()

                // Cheat
                VStack {
                    Text("Cheat")
                        .foregroundColor(viewModel.isCheatMode ? .red : .black)
                    Image("cheatMode")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 66, height: 66, alignment: .center)
                }
                .onLongPressGesture(
                    minimumDuration: 5,
                    maximumDistance: 0,
                    pressing: { inProgress in
//                        isCheatMode = inProgress
                        if inProgress {
                            viewModel.cheatModeOn()
                        } else {
                            viewModel.cheatModeOff()
                        }
                    },
                    perform: {
//                        isCheatMode = false
//                        cheatPrompt = nil
                        viewModel.cheatModeOff()
                    }
                )


            }

        }
        .coordinateSpace(name: "board")
        .onPreferenceChange(StoredRectPreferenceKey.self) { preferences in
            for p in preferences {
                self.storedRects¨[p.id] = p.rect
            }
        }
        .padding()
        
    }
    
    

    func newGame() {
            viewModel.newGame()
    }
    
    
    func startDealingAnimation(for card: SetGameModel.Card) {
        dealingAdjustments¨[card.id] = dealingAdjustmentForCard(card)
        withAnimation(.easeInOut(duration: 0.3)){
            dealingAdjustments¨[card.id] = DealingAdjustment.noDeviation
        }
    }
    
    func dealingAdjustmentForCard(_ card: SetGameModel.Card) -> DealingAdjustment {
        guard let cardRect = storedRects¨[card.id] else { return DealingAdjustment.noDeviation }
        guard let deckRect = storedRects¨["deck"] else { return DealingAdjustment.noDeviation }
        
        let offset =  CGSize(
            width: deckRect.minX - cardRect.minX,
            height: deckRect.minY - cardRect.minY
        )
        
        let scale =  CGSize(
            width: deckRect.width / cardRect.width,
            height: deckRect.height / cardRect.height
        )

        return DealingAdjustment(offset: offset, scale: scale, rotation: 180)
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
