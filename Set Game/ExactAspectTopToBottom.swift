//
//  ExactAspectTopToBottom.swift
//  TestDifferentGrid
//
//  Created by Fedor Boretskiy on 14.12.2020.
//

import SwiftUI


protocol GridLayoutWithGap {
    init(itemCount: Int, desiredItemAspectRatio: Double, areaSize: CGSize, gap: CGFloat)
    var itemSize: CGSize { get }
    func location(ofItemAt index: Int) -> CGPoint
}


struct ExactAspectTopToBottom: GridLayoutWithGap {
    let desiredItemAspectRatio: Double
    var areaSize: CGSize
    var gap: CGFloat
    var rowCount: Int = 0
    var columnCount: Int = 0
    
    init(itemCount: Int, desiredItemAspectRatio: Double = 1, areaSize: CGSize, gap: CGFloat) {
        self.areaSize = areaSize
        self.desiredItemAspectRatio = desiredItemAspectRatio
        self.gap = gap
        // if our size is zero width or height or the itemCount is not > 0
        // then we have no work to do (because our rowCount & columnCount will be zero)
        guard areaSize.width != 0, areaSize.height != 0, itemCount > 0 else { return }
        // find the bestLayout
        // i.e., one which results in cells whose:
        // - aspectRatio is exact as desired
        // - area of item has maximum possible value
        // - items in first row fill width of area
        // - height of item is not bigger than area height
        var bestLayout: (rowCount: Int, columnCount: Int) = (1, itemCount)
        var largestItemArea: CGFloat?
        for columns in 1...itemCount {
            let rows = (itemCount / columns) + (itemCount % columns > 0 ? 1 : 0)
            let itemSize = itemSizeFor(rows: rows, columns: columns)
            let itemArea = itemSize.width * itemSize.height
            if largestItemArea == nil || itemArea > largestItemArea! {
                largestItemArea = itemArea
                bestLayout = (rowCount: rows, columnCount: columns)
            }
        }
        rowCount = bestLayout.rowCount
        columnCount = bestLayout.columnCount
    }
    
    func itemSizeFor(rows: Int, columns: Int) -> CGSize {
        if rows == 0 || columns == 0 {
            return CGSize.zero
        }
        let itemWidth = (areaSize.width - gap * CGFloat(columns - 1)) / CGFloat(columns)
        let itemHeight = itemWidth / CGFloat(desiredItemAspectRatio)
        if itemHeight * CGFloat(rows) + gap * CGFloat(rows - 1) > areaSize.height {
            return CGSize(width: 0, height: 0)
        } else {
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    var itemSize: CGSize {
        return itemSizeFor(rows: rowCount, columns: columnCount)
//        if rowCount == 0 || columnCount == 0 {
//            return CGSize.zero
//        } else {
//            return CGSize(
//                width: areaSize.width / CGFloat(columnCount),
//                height: areaSize.height / CGFloat(rowCount)
//            )
//        }
    }
    
    func location(ofItemAt index: Int) -> CGPoint {
        let rowPos = CGFloat(index / columnCount)
        let colPos = CGFloat(index % columnCount)
        if rowCount == 0 || columnCount == 0 {
            return CGPoint.zero
        } else {
            return CGPoint(
                x: 0.5 * itemSize.width + (itemSize.width + gap) * colPos,
                y: 0.5 * itemSize.height + (itemSize.height + gap) * rowPos
            )
        }
    }
}
