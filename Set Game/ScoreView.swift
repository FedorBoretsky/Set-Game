//
//  ScoreView.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 12.04.2021.
//

import SwiftUI

struct ScoreView: View {
    let score: Double
    
    var body: some View {
        ZStack {
            Text("\(score < 0 ? "−" : "")\(abs(score), specifier: "%g")")
                .foregroundColor(UX.infoColor)
                .font(.system(size: 27, weight: .bold, design: .rounded))
//                .offset(y: -8)
//            if let text = label {
//            Text(text.uppercased())
//                .foregroundColor(UX.infoColor)
//                .font(Font.system(size: 9, weight: .heavy, design: .rounded))
//                .offset(y: 14)
//            }
        }
        .frame(width: UX.bigRoundButtonSize, height: 32)
//        .clipShape(Rectangle())
    }
}

struct ScoreWithLableView: View {
    let score: Double
    var label = "Score"
    
    var body: some View {
        ZStack {
            ScoreView(score: score)
                .offset(y: -8)
            Text(label.uppercased())
                .foregroundColor(UX.infoColor)
                .font(Font.system(size: 9, weight: .heavy, design: .rounded))
                .offset(y: 13)
        }
        .frame(width: UX.bigRoundButtonSize, height: UX.bigRoundButtonSize)
    }
}


struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            UX.backgroundColor
                .ignoresSafeArea(.all)
            
            
            HStack {
                
                ScoreView(score: -13)
                
                ScoreWithLableView(score: -13)

                BigRoundButtonView{
                    
                } label: {
                    BigRoundButtonLabel.cheat
                }
                //                .disabled(true)

                BigRoundButtonView{
                    
                } label: {
                    BigRoundButtonLabel.ladygug
                }
//                .disabled(true)
                
            }
        }
    }
}
