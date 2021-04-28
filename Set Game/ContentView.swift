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
    
    @State private var ii = 0
    
    let playersNumCases = ["person.fill", "person.2"]
    
    
    @State private var showingRules = false
    
    var body: some View {
        ZStack {
            
            UX.backgroundColor
                .edgesIgnoringSafeArea(.all)

            VStack {
                
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
                
                Spacer()
                
                //
                // Game controls
                
                if viewModel.numberOfPlayers == 1 {
                    HStack(alignment: .bottom, spacing: 12){
                        // Score
                        ScoreWithLableView(score: viewModel.scoreOfPlayer(0))
                            .padding(.bottom, 15)
                        
                        // Deck
                        Button {
                            viewModel.deal3Cards()
                        } label : {
                            DeckView(deckCards: viewModel.deckCards)
                        }
                        .disabled(viewModel.isCheatMode || viewModel.isDeckEmpty)
                        
                        // Cheat button
                        BigRoundButtonView{
                            viewModel.cheatModeOn()
                        } label: {
                            BigRoundButtonLabel.cheat
                        }
                        .padding(.bottom, 15)
                        
                    }
                    .padding(.bottom)
                }
                
                if viewModel.numberOfPlayers == 2 {
                    HStack(alignment: .bottom, spacing: 12){
                        
                        // 1st player
                        VStack(spacing: 2) {
                            ScoreView(score: viewModel.scoreOfPlayer(0))
                            BigRoundButtonView{
                                viewModel.activatePlayer(0)
                            } label: {
                                BigRoundButtonLabel.ladygug
                            }
                        }
                        .disabled(viewModel.activePlayerIndex == 1)
                        .padding(.bottom, 15)

                        // Deck
                        Button {
                                viewModel.deal3Cards()
                        } label : {
                            DeckView(deckCards: viewModel.deckCards)
                        }
                        .disabled(!viewModel.isThereActivePlayer || viewModel.isDeckEmpty)
                        
                        // 2nd player
                        VStack(spacing: 2) {
                            ScoreView(score: viewModel.scoreOfPlayer(1))
                            BigRoundButtonView {
                                viewModel.activatePlayer(1)
                            } label: {
                                BigRoundButtonLabel.ant
                            }
                        }
                        .disabled(viewModel.activePlayerIndex == 0)
                        .padding(.bottom, 15)
                        
                    }
                }
                

                    
//
//                    // Two players mode – Score and activation of 1st player.
//                    if viewModel.numberOfPlayers == 2 {
//                        Button {
//                            viewModel.activatePlayer(0)
//                        } label: {
//                            VStack(alignment: .leading){
//                                Text("Player 1")
//                                Text("\(viewModel.scoreOfPlayer(0), specifier: "%g")")
//                                    .font(Font.system(size: scoreFrameSize, weight: .thin))
//                                    .foregroundColor(.primary)
//                            }
//                            .animation(.none)
//                        }
//                        .disabled(viewModel.isThereActivePlayer)
//                    }
//
//                    Spacer()
//
                    

//
//
//
//                    // Two players mode – Score and activation of 2nd player.
//                    if viewModel.numberOfPlayers == 2 {
//                        Button {
//                            viewModel.activatePlayer(1)
//                        } label: {
//                            VStack(alignment: .leading){
//                                Text("Player 2")
//                                Text("\(viewModel.scoreOfPlayer(1), specifier: "%g")")
//                                    .font(Font.system(size: scoreFrameSize, weight: .thin))
//                                    .foregroundColor(.primary)
//                            }
//                            .animation(.none)
//                        }
//                        .disabled(viewModel.isThereActivePlayer)
//                    }
//
//
//
//                    // Cheat
//                    if viewModel.numberOfPlayers == 1 {
//                        Button {
//                            // No tap action
//                        } label: {
//                            VStack {
//                                Text("Cheat")
//                                Image("cheatMode")
//                                    .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
//                                    .frame(width: 66, height: 66, alignment: .center)
//                            }
//                            .onLongPressGesture(
//                                minimumDuration: 5,
//                                maximumDistance: 0,
//                                pressing: { inProgress in
//                                    if inProgress {
//                                        viewModel.cheatModeOn()
//                                    } else {
//                                        viewModel.cheatModeOff()
//                                    }
//                                },
//                                perform: {
//                                    viewModel.cheatModeOff()
//                                }
//                            )
//                        }
//                    }
//                }
                
                // Appliсation menu
                                
                HStack(alignment: .firstTextBaseline){
                    
                    Button("NEW \nGAME") {
                        viewModel.newGame()
                    }
                    
                    Spacer(minLength: 0)
                    
                    Button("ONE \nPLAYER") {
                        viewModel.newSinglePlayerGame()
                    }
                    .foregroundColor(viewModel.numberOfPlayers == 1 ? UX.menuHighlightColor : UX.menuNormalColor)

                    Spacer(minLength: 0)
                    
                    Button("TWO \nPLAYERS") {
                        viewModel.newTwoPlayerGame()
                    }
                    .foregroundColor(viewModel.numberOfPlayers == 2 ? UX.menuHighlightColor : UX.menuNormalColor)
                    
                    Spacer(minLength: 0)
                    
                    Button("GAME \nRULES") {
                        self.showingRules = true
                    }
                    .sheet(isPresented: $showingRules) {
                        RulesView()
//                            .foregroundColor(UX.backgroundColor)
                    }

                }
                .padding(.top, 10)
                .font(Font.system(size: 11.5, weight: .bold, design: .rounded))
                .foregroundColor(UX.menuNormalColor)

            }
            .coordinateSpace(name: "board")
            .onPreferenceChange(StoredRectPreferenceKey.self) { preferences in
                for p in preferences {
                    self.storedRects¨[p.id] = p.rect
                }
            }
            .padding()
            .onAppear{ viewModel.newSinglePlayerGame() }

        }
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
            .preferredColorScheme(.dark)
    }
}

