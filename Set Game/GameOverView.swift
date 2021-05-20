//
//  GameOverView.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 13.05.2021.
//

import SwiftUI

struct GameOverView: View {
    var body: some View {
        VStack{
            Text("Game over!")
                .font(.title)
                .padding(44)
        }
        .background(RoundedRectangle(cornerRadius: 11).foregroundColor(UX.gameOverBackgroundColor))
        .shadow(color: Color.black.opacity(0.25), radius: 11, x: 0, y: 0)
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            UX.backgroundColor
                .ignoresSafeArea(.all)
            GameOverView()
        }
    }
}
