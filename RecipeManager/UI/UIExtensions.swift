//
//  UIExtension.swift
//  RecipeManager
//
//  Created by Guido Roos on 11/09/2023.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat) -> some View {
        modifier(CornerRadiusModifier(cornerRadius: radius))
    }

    func defaultShadow() -> some View {
        modifier(DefaultShadowModifier())
    }
}

struct CornerRadiusModifier: ViewModifier {
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

struct DefaultShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
