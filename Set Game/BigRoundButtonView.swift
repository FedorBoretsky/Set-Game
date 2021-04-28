//
//  BigRoundButtonView.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 11.04.2021.
//

import SwiftUI

struct BigRoundButtonView<Content: View>: View {
    
    let part: Double
    let action: () -> Void
    let content: Content
    
    @Environment(\.isEnabled) var isEnabled
    
    init (progress part: Double = 0, action: @escaping () -> Void, @ViewBuilder label: () -> Content) {
        // TODO: Rename "progress" argument label and rethink about type. Maybe optional is better.
        self.part = part
        self.action = action
        self.content = label()
    }
    
    
    
    var body: some View {
        ZStack{
            // Background
            backgroundColor()
            // Content
            self.content
                .foregroundColor(contentColor())
            // Progressbar
            if isEnabled && part > 0 {
                Circle()
                    .inset(by: UX.circularProgressBarLineWidth/2)
                    .trim(from: 0, to: CGFloat(part))
                    .stroke(style: StrokeStyle(
                                lineWidth: UX.circularProgressBarLineWidth,
                                lineCap: .round,
                                lineJoin: .round)
                    )
                    .rotationEffect(Angle(degrees: -90))
                    .foregroundColor(UX.circularProgressBarColor)
                    .animation(.linear)
            }
        }
        .onTapGesture(perform: self.action)
        .frame(width: UX.bigRoundButtonSize, height: UX.bigRoundButtonSize)
        .clipShape(Circle())
    }
    
    func backgroundColor() -> Color {
        if isEnabled {
            if part > 0 {
                return UX.circularProgressBarBackground
            } else {
                return UX.bigRoundButtonBackgroundColor
            }
        } else {
            return UX.bigRoundButtonDisabledBackgroundColor
        }
    }

    func contentColor() -> Color {
        if isEnabled {
            if part > 0 {
                return UX.circularProgressBarColor
            } else {
                return UX.bigRoundButtonContentColor
            }
        } else {
            return UX.bigRoundButtonDisabledContentColor
        }
    }

}


struct BigRoundButtonLabel {
    
    static var ladygug: some View {
        Image(systemName: "ladybug.fill")
            .font(Font.system(size: 30, weight: .thin))
    }
    
    static var ant: some View {
        Image(systemName: "ant.fill")
            .font(Font.system(size: 30, weight: .thin))
    }
    
    static var cheat: some View {
        VStack(spacing: 4) {
            Image("CheatIcon")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20.5)
            Text("CHEAT")
                .font(Font.system(size: 9, weight: .heavy, design: .rounded))
        }
    }
}



struct BigRoundButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            UX.backgroundColor
                .ignoresSafeArea(.all)
            
            HStack(spacing: 15) {
                
                BigRoundButtonView{
                    
                } label: {
                    BigRoundButtonLabel.ladygug
                }
//                .disabled(true)
                
                BigRoundButtonView{
                    
                } label: {
                    BigRoundButtonLabel.cheat
                }
//                .disabled(true)

                BigRoundButtonView(progress: 0.35){
                    
                } label: {
                    BigRoundButtonLabel.ant
                }
//                .disabled(true)
            }
        }
    }
}
