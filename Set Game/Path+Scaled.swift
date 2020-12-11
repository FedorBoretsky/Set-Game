//
//  Path+Scaled.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 11.12.2020.
//

import SwiftUI

extension Path {
    func scaled(toFit rect: CGRect) -> Path {
        let scaleW = rect.width/boundingRect.width
        let scaleH = rect.height/boundingRect.height
        let scaleFactor = min(scaleW, scaleH)
        return applying(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
    }
    
    func fit(to rect: CGRect) -> Path {
        let dX = rect.minX - boundingRect.minX
        let dY = rect.minY - boundingRect.minY
        return scaled(toFit: rect).applying(CGAffineTransform(translationX: dX, y: dY))
        
    }
    
}

/* Using:
 
 struct MyShape(myCustomBezier: UIBezierPath) : Shape {
    var myCustomBezier : UIBezierPath
    func path(in rect: CGRect) -> Path {
        let path = Path(myCustomBezier.cgPath)
        return path.scaled(toFit: rect)
    }
 }
 
 */
