//
//  ContentView.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 06.12.2020.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Cards 1, 2, 3  \(SetGameModel.isSet(testData[1], testData[2], testData[3]) ? "form a Set" : "don't form a Set.")")
            Text("Cards 4, 5, 6  \(SetGameModel.isSet(testData[4], testData[5], testData[6]) ? "form a Set" : "don't form a Set.")")
            Text("Cards 7, 8, 9  \(SetGameModel.isSet(testData[7], testData[8], testData[9]) ? "form a Set" : "don't form a Set.")")
            Text("Cards 10, 11, 12  \(SetGameModel.isSet(testData[10], testData[11], testData[12]) ? "form a Set" : "don't form a Set.")")
        }
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
