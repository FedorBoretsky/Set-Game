//
//  GridWithGap.swift
//  TestDifferentGrid
//
//  Created by Fedor Boretskiy on 14.12.2020.
//


import SwiftUI

struct GridWithGap<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    private var items¨: [Item]
    private var aspectRatio: Double
    private var gap: CGFloat
    private var viewForItem: (Item) -> ItemView

    
    init (_ items¨: [Item], aspectRatio: Double = 1, gap: CGFloat, viewForItem: @escaping (Item) -> ItemView) {
        self.items¨ = items¨
        self.aspectRatio = aspectRatio
        self.gap = gap
        self.viewForItem = viewForItem
    }

    var body: some View {
        GeometryReader { geometry in
                body(for: ExactAspectTopToBottom(itemCount: self.items¨.count, desiredItemAspectRatio: aspectRatio, areaSize: geometry.size, gap: gap))
        }
        .animation(.default)
    }
    
    private func body(for layout: GridLayoutWithGap) -> some View {
        ForEach(items¨.reversed()) { item in
            bodyOfItem(for: item, in: layout)
        }
    }
    
    private func bodyOfItem(for item: Item, in layout: GridLayoutWithGap) -> some View {
        let index = items¨.firstIndex(matching: item)!
        return viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index))
    }

    
}

