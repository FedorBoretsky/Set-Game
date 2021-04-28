//
//  RulesStyles.swift
//  Set Game
//
//  Created by Fedor Boretskiy on 23.04.2021.
//

import SwiftUI

/// Header style
struct RulesH1: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.system(.title, design: .rounded).weight(.bold))
            .padding(.vertical)
    }
}

/// Paragraph style
struct RulesP: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(nil)
            .padding(.bottom)
    }
}

/// Image Caption style
struct RulesImageCaption: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .frame(maxWidth: .infinity)
    }
}

/// Row Title style
struct RulesRowTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Table of Feature Row style
struct RulesTableOfFeatureRow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.trailing)
    }
}

/// Example Feature style
struct RulesExampleFeature: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(alignment: .leading)
            .lineLimit(1)
    }
}

/// Example Feature Check style
struct RulesExampleFeatureCheck: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(nil)
    }
}

/// Example Block style
struct RulesExampleBlock: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.bottom)
            .padding(.bottom)
    }
}



// Using modifiers normal way
extension View {
    
    func rulesH1() -> some View {
        self.modifier(RulesH1())
    }
    
    func rulesP() -> some View {
        self.modifier(RulesP())
    }
        
    func rulesImageCaption() -> some View {
        self.modifier(RulesImageCaption())
    }
    
    func rulesRowTitle() -> some View {
        self.modifier(RulesRowTitle())
    }
    
    func rulesTableOfFeatureRow() -> some View {
        self.modifier(RulesTableOfFeatureRow())
    }
    
    func rulesExampleFeature() -> some View {
        self.modifier(RulesExampleFeature())
    }
    func rulesExampleFeatureCheck() -> some View {
        self.modifier(RulesExampleFeatureCheck())
    }
    func rulesExampleBlock() -> some View {
        self.modifier(RulesExampleBlock())
    }
    
}
