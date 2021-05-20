//
//  UX.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 26.03.2021.
//

import SwiftUI

struct UX {
    // Color scheme is based on design
    // of manual of the phisical game.
    static let backgroundColor = Color(#colorLiteral(red: 0.3412573338, green: 0.1643419564, blue: 0.4281123877, alpha: 1))
    static let cardShapeRedColor = Color(#colorLiteral(red: 0.8685824275, green: 0.2308763862, blue: 0.2543166876, alpha: 1))
    static let cardShapeGreenColor = Color(#colorLiteral(red: 0, green: 0.6561744213, blue: 0.337438941, alpha: 1))
    static let cardShapePurpleColor = Color(#colorLiteral(red: 0.2361068726, green: 0.1733816564, blue: 0.4722234011, alpha: 1))
    static let cardCoverPatternColor = Color(#colorLiteral(red: 0.5635849833, green: 0.4579914212, blue: 0.6192191243, alpha: 1))
    static let infoColor = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    static let highlightColor = Color(#colorLiteral(red: 1, green: 0.797763586, blue: 0.1193134263, alpha: 1))
    static let bigRoundButtonContentColor = backgroundColor
    static let bigRoundButtonBackgroundColor = infoColor
    static let bigRoundButtonDisabledContentColor = Color(#colorLiteral(red: 0.6117647059, green: 0.4980392157, blue: 0.6705882353, alpha: 1))
    static let bigRoundButtonDisabledBackgroundColor = backgroundColor
    static let circularProgressBarBackground = Color(#colorLiteral(red: 0.4039215686, green: 0.2588235294, blue: 0.4784313725, alpha: 1))
    static let circularProgressBarColor = highlightColor
    static let menuNormalColor = infoColor
    static let menuHighlightColor = highlightColor
    static let gameOverBackgroundColor = Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))

    // Size
    static let bigRoundButtonSize: CGFloat = 67
    static let circularProgressBarLineWidth: CGFloat = 4


}

//switch cardFeature {
//case .red:
//    return Color(#colorLiteral(red: 0.9449447989, green: 0.5995458961, blue: 0.4950096011, alpha: 1))
//case .green:
//    return Color(#colorLiteral(red: 1, green: 0.8101983339, blue: 0.4036157531, alpha: 1))
//case .purple:
//    return Color(#colorLiteral(red: 0.5390414985, green: 0.8129923543, blue: 0.8687104583, alpha: 1))
//}

