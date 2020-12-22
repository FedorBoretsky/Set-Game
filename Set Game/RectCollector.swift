//
//  RectCollector.swift
//  Test2
//
//  Created by Fedor Boretskiy on 21.12.2020.
//

import SwiftUI

struct StoredRect: Equatable {
    let id: String
    let rect: CGRect
    static func == (lhs: StoredRect, rhs: StoredRect) -> Bool {
        return (lhs.id == rhs.id) && (lhs.rect == rhs.rect)
    }
}

struct StoredRectPreferenceKey: PreferenceKey {
    typealias Value = [StoredRect]
    
    static var defaultValue: [StoredRect] = []
    
    static func reduce(value: inout [StoredRect], nextValue: () -> [StoredRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct MyPreferenceViewSetter: View {
    let id: String
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(key: StoredRectPreferenceKey.self,
                            value: [StoredRect(id: self.id, rect: geometry.frame(in: .named("board")))])
        }
    }
}

