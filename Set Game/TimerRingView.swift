//
//  TimerRingView.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 03.05.2021.
//

import SwiftUI

struct TimerRingView<Label: View>: View {
    let seconds: Double
    let label: Label
    
    @State private var progress: Double = 1.0
    
    init(seconds: Double, @ViewBuilder label: ()->Label){
        self.seconds = seconds
        self.label = label()
    }
    
    var body: some View {
        ZStack {
            // Background
            Circle()
                .fill(UX.circularProgressBarBackground)
            // Label
            self.label
                .foregroundColor(UX.circularProgressBarColor)
            // Progress ring
            ProgressRingView(progress: progress)
                .onAppear{
                    withAnimation(.linear(duration: seconds)){
                        progress = 0
                    }
            }
        }
    }
}

private struct TimerRun_Preview: View {
    
    @State private var progress = 0.35
    @State private var isTimerHere: Bool = false
    
    var body: some View {
        
        VStack(spacing: 25){
            
            Group {
                if isTimerHere {
                    TimerRingView(seconds: 4){
                        Text("AAA")
                    }
                }
            }
            .frame(width: 100, height: 100, alignment: .center)
            
            
            Button{
                withAnimation{
                    isTimerHere.toggle()
                }
            } label: {
                Rectangle()
                    .foregroundColor(UX.circularProgressBarColor)
                    .frame(width: 100, height: 100)
            }
        }
        
    }
}
struct TimerRingView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            UX.backgroundColor.ignoresSafeArea(.all)
            TimerRun_Preview()
        }
    }
}
