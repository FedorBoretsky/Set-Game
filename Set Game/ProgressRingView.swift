//
//  ProgressRingView.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 03.05.2021.
//

import SwiftUI

struct ProgressRingView: View {
    
    let progress: Double
    
    var body: some View {
        Circle()
            .inset(by: UX.circularProgressBarLineWidth/2)
            .trim(from: 0, to: CGFloat(progress))
            .stroke(style: StrokeStyle(
                        lineWidth: UX.circularProgressBarLineWidth,
                        lineCap: .round,
                        lineJoin: .round)
            )
            .rotationEffect(Angle(degrees: -90))
            .foregroundColor(UX.circularProgressBarColor)
    }
}



struct ProgressRingView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            UX.backgroundColor.ignoresSafeArea(.all)
            ProgressRingView(progress: 0.75)
                .padding()
        }
    }
}
