//
//  CardView.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 06.12.2020.
//

import SwiftUI

private let shapeWidthFactor: CGFloat = 0.21
private let cornerRadiusFactor: CGFloat = 1/12

struct CardView: View {
    let card: SetGameModel.Card
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: geometry.size.height * cornerRadiusFactor)
                    .stroke(Color.gray.opacity(0.75), lineWidth: 1)
                    .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 0)
                RoundedRectangle(cornerRadius: geometry.size.height * cornerRadiusFactor)
                    .foregroundColor(.white)
                HStack(spacing: 0) {
                    Spacer()
                    
                    HStack(spacing: geometry.size.width/14) {
                        ForEach(0..<card.number.rawValue) { item in
                            getSingleSymbol(shapeFeature: card.shape, shadingFeature: card.shading, colorFeature: card.color)
                                .frame(width: geometry.size.width * shapeWidthFactor)
                        }
                    }
                    .layoutPriority(1)
                    
                    Spacer()
                }
            }
        }
        .aspectRatio(1.5, contentMode: .fit)
    }
    
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
//                CardView(card: SetGameModel.Card(color: .green, number: .three, shape: .oval, shading: .open))
//                CardView(card: SetGameModel.Card(color: .green, number: .one, shape: .diamond, shading: .solid))
                CardView(card: SetGameModel.Card(color: .green, number: .one, shape: .diamond, shading: .solid))
                CardView(card: SetGameModel.Card(color: .red, number: .three, shape: .diamond, shading: .striped))
            }
            HStack(spacing: 16) {
//                CardView(card: SetGameModel.Card(color: .green, number: .three, shape: .squiggle, shading: .solid))
                CardView(card: SetGameModel.Card(color: .purple, number: .two, shape: .diamond, shading: .solid))
                CardView(card: SetGameModel.Card(color: .purple, number: .two, shape: .diamond, shading: .solid))
                CardView(card: SetGameModel.Card(color: .red, number: .two, shape: .squiggle, shading: .solid))
            }
            HStack(spacing: 16) {
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open))
                CardView(card: SetGameModel.Card(color: .green, number: .three, shape: .oval, shading: .striped))
                CardView(card: SetGameModel.Card(color: .green, number: .three, shape: .oval, shading: .striped))
                CardView(card: SetGameModel.Card(color: .red, number: .two, shape: .diamond, shading: .striped))
            }
            HStack(spacing: 16) {
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open))
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open))
                CardView(card: SetGameModel.Card(color: .green, number: .three, shape: .oval, shading: .striped))
                CardView(card: SetGameModel.Card(color: .red, number: .two, shape: .diamond, shading: .striped))
            }
            HStack(spacing: 16) {
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open))
                CardView(card: SetGameModel.Card(color: .green, number: .three, shape: .oval, shading: .striped))
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open))
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open))
            }
            HStack(spacing: 16) {
                CardView(card: SetGameModel.Card(color: .green, number: .two, shape: .oval, shading: .solid))
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open))
                CardView(card: SetGameModel.Card(color: .purple, number: .three, shape: .diamond, shading: .open))
                CardView(card: SetGameModel.Card(color: .purple, number: .two, shape: .diamond, shading: .solid))
            }
        }
        .padding()
    }
}


struct AnyShape: Shape {
    private let _path: (CGRect) -> Path
    
    init<S: Shape>(_ wrapped: S) {
        _path = {
            rect in
            let path = wrapped.path(in: rect)
            return path
        }
    }

    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }
}

struct Symbol: View {
    let shapeFeature: SetGameModel.ShapeFeature
    let shadingFeature: SetGameModel.ShadingFeature
    let colorFeature: SetGameModel.ColorFeature
    let numberFeature: SetGameModel.NumberFeature
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Spacer()
                
                HStack(spacing: geometry.size.width/14) {
                    ForEach(0..<numberFeature.rawValue) { item in
                        getSingleSymbol(shapeFeature: shapeFeature, shadingFeature: shadingFeature, colorFeature: colorFeature)
                            .frame(width: geometry.size.width * shapeWidthFactor)
                    }
                }
                .layoutPriority(1)

                Spacer()
            }
        }
    }
}


func getSingleSymbol(shapeFeature: SetGameModel.ShapeFeature,
               shadingFeature: SetGameModel.ShadingFeature,
               colorFeature: SetGameModel.ColorFeature) -> some View
{
    var symbol: AnyShape
    switch shapeFeature {
        case .diamond:
            symbol = AnyShape(Diamond())
        case .squiggle:
            symbol = AnyShape(Squiggle())
        case .oval:
            symbol = AnyShape(Oval())
    }
    
    let color = colorForFeatureValue(colorFeature)
    
    switch shadingFeature {
    case .open:
        return ZStack{
            symbol.foregroundColor(.white).opacity(1)
            Striped().foregroundColor(.clear).clipShape(symbol)
            symbol.stroke(color, lineWidth: 3)
        }
    case .solid:
        return ZStack{
            symbol.foregroundColor(color).opacity(1)
            Striped().foregroundColor(.clear).clipShape(symbol)
            symbol.stroke(color, lineWidth: 3)
        }
    case .striped:
        return ZStack{
            symbol.foregroundColor(color).opacity(0)
            Striped().foregroundColor(color).clipShape(symbol)
            symbol.stroke(color, lineWidth: 3)
        }
    }
    
}

private func colorForFeatureValue(_ colorFeature: SetGameModel.ColorFeature) -> Color {
    switch colorFeature {
    case .red:
        return Color(#colorLiteral(red: 0.9449447989, green: 0.5995458961, blue: 0.4950096011, alpha: 1))
    case .green:
        return Color(#colorLiteral(red: 1, green: 0.8101983339, blue: 0.4036157531, alpha: 1))
    case .purple:
        return Color(#colorLiteral(red: 0.5390414985, green: 0.8129923543, blue: 0.8687104583, alpha: 1))
//    case .red:
//        return Color(#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1))
//    case .green:
//        return Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
//    case .purple:
//        return Color(#colorLiteral(red: 0.5514659715, green: 0.02691722973, blue: 0.7921356223, alpha: 1))
    }
}

// MARK: - Symbol's shapes

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        let ratio: CGFloat = 0.5
        
        var width = ratio * rect.height
        var height = rect.height
        if width > rect.width {
            width = rect.width
            height = width / ratio
        }
        
        let symbolRect = CGRect(x: rect.midX - width / 2,
                                y: rect.midY - height / 2,
                                width: width,
                                height: height)
        
        var p = Path()
        
        p.move(to: CGPoint(x: symbolRect.midX, y: symbolRect.minY))
        p.addLine(to: CGPoint(x: symbolRect.minX, y: symbolRect.midY))
        p.addLine(to: CGPoint(x: symbolRect.midX, y: symbolRect.maxY))
        p.addLine(to: CGPoint(x: symbolRect.maxX, y: symbolRect.midY))
        p.addLine(to: CGPoint(x: symbolRect.midX, y: symbolRect.minY))
        
        return p
    }
}

struct Oval: Shape {
    func path(in rect: CGRect) -> Path {
        let ratio: CGFloat = 0.5
        
        var width = ratio * rect.height
        var height = rect.height
        if width > rect.width {
            width = rect.width
            height = width / ratio
        }
        
        width *= 0.98
        height *= 0.96
        
        let baseSquare = CGRect(x: rect.midX - width / 2,
                              y: rect.midY - height / 4,
                              width: width,
                              height: height / 2)

        var p = Path()
        
        p.move(to: CGPoint(x: baseSquare.minX, y: baseSquare.minY ))
        p.addLine(to: CGPoint(x: baseSquare.minX, y: baseSquare.maxY))
        p.addArc(center: CGPoint(x: baseSquare.midX, y: baseSquare.maxY),
                 radius: width / 2,
                 startAngle: Angle.degrees(180),
                 endAngle: Angle.degrees(0),
                 clockwise: true)
        p.addLine(to: CGPoint(x: baseSquare.maxX, y: baseSquare.minY))
        p.addArc(center: CGPoint(x: baseSquare.midX, y: baseSquare.minY),
                 radius: width / 2,
                 startAngle: Angle.degrees(0),
                 endAngle: Angle.degrees(180),
                 clockwise: true)
        
        return p
    }
}

struct Squiggle: Shape {
    
    static var squiggleHandDrawnShape : UIBezierPath {
        get {
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
            return shape
        }
    }

    func path(in rect: CGRect) -> Path {
        let ratio: CGFloat = 0.5
        
        var width = ratio * rect.height
        var height = rect.height
        if width > rect.width {
            width = rect.width
            height = width / ratio
        }
        
        width *= 0.98
        height *= 0.96
        
        let symbolRect = CGRect(x: rect.midX - width / 2,
                                y: rect.midY - height / 2,
                                width: width,
                                height: height)
        
        var p = Path(Self.squiggleHandDrawnShape.cgPath)
        p = p.fit(to: symbolRect)

        return p
    }
}

struct Striped: Shape {
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
