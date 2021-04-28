//
//  CardFace.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 15.12.2020.
//

import SwiftUI



func colorForFeatureValue(_ cardFeature: SetGameModel.Card.ColorFeature) -> Color {
    switch cardFeature {
    case .red:
        return UX.cardShapeRedColor
    case .green:
        return UX.cardShapeGreenColor
    case .purple:
        return UX.cardShapePurpleColor
    }
}

private struct Striped: Shape {
    let stripeWidth: CGFloat = 1
    let gap: CGFloat = 4
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        for y in stride(from: gap, to: rect.maxY, by: gap) {
            p.addRect(CGRect(x: rect.minX, y: y, width: rect.width, height: stripeWidth))
        }
        return p
    }
}


// MARK: -

struct CardFace: View {
    let card: SetGameModel.Card
    
    var body: some View {
        
        var shapeFactory: (_ rect: CGRect, _ insetAmount: CGFloat) -> Path
        
        switch card.shape {
            case .diamond:
                shapeFactory = diamondFactory
            case .squiggle:
                shapeFactory = squiggleFactory
            case .oval:
                shapeFactory = ovalFactory
        }
        
        let symbol = FaceSymbol(shapeFactory: shapeFactory, numberOfShapes: card.number.rawValue)
        
        
        let color = colorForFeatureValue(card.color)
        
        switch card.shading {
        case .open:
            return ZStack{
                symbol.foregroundColor(.white).opacity(1)
                Striped().foregroundColor(.clear).clipShape(symbol)
                symbol.strokeBorder(color, lineWidth: 2)
            }
        case .solid:
            return ZStack{
                symbol.foregroundColor(color).opacity(1)
                Striped().foregroundColor(.clear).clipShape(symbol)
                symbol.strokeBorder(color, lineWidth: 2)
            }
        case .striped:
            return ZStack{
                symbol.foregroundColor(.white).opacity(0)
                Striped().foregroundColor(color).clipShape(symbol)
                symbol.strokeBorder(color, lineWidth: 2)
            }
        }
    }
}

struct SetGameSymbol_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.clear)
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.primary, lineWidth: 0.5)
            CardFace(card: SetGameModel.Card(color: .green, number: .three, shape: .oval, shading: .solid))
        }.frame(width: 90, height: 60)
    }
}


// MARK: - FaceSymbol

struct FaceSymbol: InsettableShape {
    let shapeFactory: (_ rect: CGRect, _ insetAmount: CGFloat) -> Path
    var numberOfShapes: Int
    var insetAmount: CGFloat = 0

    func inset(by amount: CGFloat) -> some InsettableShape {
        var iShape = self
        iShape.insetAmount += amount
        return iShape
    }
    
    func path(in rect: CGRect) -> Path {
        
        let symbolAspectRatio: CGFloat = 14 / 8
        
        //  Calculate area for symbol
        //
        var symbolRect: CGRect
        if rect.height * symbolAspectRatio > rect.width {
            symbolRect = CGRect(
                x: rect.minX,
                y: rect.minY,
                width: rect.width,
                height: rect.width / symbolAspectRatio
            )
        } else {
            symbolRect = CGRect(
                x: rect.minX,
                y: rect.minY,
                width: rect.height * symbolAspectRatio,
                height: rect.height
            )
        }
        let marginsScaleFactor: CGFloat = 0.7
        // 0.77 looks like phisical game
        // 0.6 looks accurate (but may be small)
        // 0.7 average
        symbolRect = symbolRect.applying(CGAffineTransform(scaleX: marginsScaleFactor, y: marginsScaleFactor))
        symbolRect = symbolRect.offsetBy(dx: rect.midX - symbolRect.midX, dy: rect.midY - symbolRect.midY)
        
        // Calculate slots
        //
        let module = symbolRect.width / 14
            
        var shapeSlot = CGRect(
            x: symbolRect.minX,
            y: symbolRect.minY,
            width: module * 4,
            height: module * 8
        )

        let gap = module
        
        // Place shapes into slots and center whole symbol
        //
        var result = Path()
        for _ in 0..<numberOfShapes {
            result.addPath(shapeFactory(shapeSlot, insetAmount))
//            result.addRect(shapeSlot)
            shapeSlot = shapeSlot.offsetBy(dx: shapeSlot.width + gap, dy: 0)
            
        }

        result = result.offsetBy(
            dx: symbolRect.midX - result.boundingRect.midX,
            dy: symbolRect.midY - result.boundingRect.midY
        )
        
        return result
    }
}


// MARK: - Shapes

func diamondFactory(in rect: CGRect, insetAmount: CGFloat) -> Path {
    var p = Path()
    p.move(to: CGPoint(x: rect.midX, y: rect.minY + insetAmount))
    p.addLine(to: CGPoint(x: rect.minX + insetAmount, y: rect.midY))
    p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - insetAmount))
    p.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.midY))
    p.addLine(to: CGPoint(x: rect.midX, y: rect.minY + insetAmount))
    return p
}

func ovalFactory(in rect: CGRect, insetAmount: CGFloat) -> Path {
    
    let width = rect.width * 0.98 - insetAmount * 2
    let height = rect.height * 0.96 - insetAmount * 2
    
    let baseRect = CGRect(x: rect.midX - width / 2,
                          y: rect.midY - height / 4,
                          width: width,
                          height: height / 2)

    var p = Path()
    p.move(to: CGPoint(x: baseRect.minX, y: baseRect.minY ))
    p.addLine(to: CGPoint(x: baseRect.minX, y: baseRect.maxY))
    p.addArc(center: CGPoint(x: baseRect.midX, y: baseRect.maxY),
             radius: width / 2,
             startAngle: Angle.degrees(180),
             endAngle: Angle.degrees(0),
             clockwise: true)
    p.addLine(to: CGPoint(x: baseRect.maxX, y: baseRect.minY))
    p.addArc(center: CGPoint(x: baseRect.midX, y: baseRect.minY),
             radius: width / 2,
             startAngle: Angle.degrees(0),
             endAngle: Angle.degrees(180),
             clockwise: true)
    return p
}


func squiggleFactory(in rect: CGRect, insetAmount: CGFloat) -> Path {
    
    // Squiggle hand-drawn shape
    let shape = UIBezierPath()
    shape.move(to: CGPoint(x: 64.41, y: 0.22))
    shape.addCurve(to: CGPoint(x: 186.83, y: 126.53), controlPoint1: CGPoint(x: 108.17, y: 0.22), controlPoint2: CGPoint(x: 186.83, y: 43.91))
    shape.addCurve(to: CGPoint(x: 157.97, y: 268.82), controlPoint1: CGPoint(x: 186.83, y: 219.99), controlPoint2: CGPoint(x: 157.97, y: 229.9))
    shape.addCurve(to: CGPoint(x: 199.94, y: 380.5), controlPoint1: CGPoint(x: 157.97, y: 317.39), controlPoint2: CGPoint(x: 199.94, y: 360.7))
    shape.addCurve(to: CGPoint(x: 129.41, y: 426.8), controlPoint1: CGPoint(x: 199.94, y: 400.29), controlPoint2: CGPoint(x: 181.37, y: 426.8))
    shape.addCurve(to: CGPoint(x: 5.22, y: 317.39), controlPoint1: CGPoint(x: 67.65, y: 426.8), controlPoint2: CGPoint(x: 5.22, y: 390.27))
    shape.addCurve(to: CGPoint(x: 44.58, y: 147.62), controlPoint1: CGPoint(x: 5.22, y: 244.51), controlPoint2: CGPoint(x: 44.58, y: 196.82))
    shape.addCurve(to: CGPoint(x: 0, y: 35.6), controlPoint1: CGPoint(x: 44.58, y: 98.42), controlPoint2: CGPoint(x: 0, y: 55.82))
    shape.addCurve(to: CGPoint(x: 64.41, y: 0.22), controlPoint1: CGPoint(x: 0, y: 15.38), controlPoint2: CGPoint(x: 20.65, y: 0.22))
    shape.close()

    
    // Fitting
    let width = rect.width * 0.98 - insetAmount * 2
    let height = rect.height * 0.96 - insetAmount * 2
    let symbolRect = CGRect(x: rect.midX - width / 2,
                            y: rect.midY - height / 2,
                            width: width,
                            height: height)
    var p = Path(shape.cgPath)
    p = p.scaled(toFit: symbolRect)
    p = p.offsetBy(dx: rect.midX - p.boundingRect.midX, dy: rect.midY - p.boundingRect.midY)
    return p
}
