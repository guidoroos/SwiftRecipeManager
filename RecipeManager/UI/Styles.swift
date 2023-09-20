//
//  Styles.swift
//  RecipeManager
//
//  Created by Guido Roos on 11/09/2023.
//

import SwiftUI

struct ColorScheme {
    static let background = Color(red: 0xFF / 255, green: 0xFE / 255, blue: 0xF8 / 255)
    static let onBackground = Color(red: 0.05, green: 0.05, blue: 0.05)
    static let primary = Color(red: 0x60 / 255, green: 0x30 / 255, blue: 0x20 / 255)
    static let onPrimary = Color(red: 0xFF / 255, green: 0xFF / 255, blue: 0xFF / 255)
    static let secondary = Color(red: 0x50 / 255, green: 0x20 / 255, blue: 0x10 / 255)
    static let onSecondary = Color(red: 0xFF / 255, green: 0xFF / 255, blue: 0xFF / 255)
    static let variant = Color(red: 255 / 255, green: 204 / 255, blue: 0 / 255)
    
    static let textfield =  Color.gray.opacity(0.2)
}

enum Typography {
    enum HeaderOne {
        static let font = Font.custom("Noteworthy-Bold", size: 28)
    }

    enum HeaderTwo {
        static let font = Font.custom("Noteworthy-Bold", size: 22)
    }

    enum FooterText {
        static let font = Font.custom("Noteworthy-Light", size: 14)
    }

    enum NormalText {
        static let font = Font.custom("Noteworthy", size: 16)
    }
}


enum Dimensions {
    static let cornerRadius: CGFloat = 8
    static let textfieldRadius: CGFloat = 4
    static let imageRadius: CGFloat = 16
}

enum Spacing {
    static let spacing1: CGFloat = 4
    static let spacing2: CGFloat = 8
    static let spacing3: CGFloat = 12
    static let spacing4: CGFloat = 16
    static let spacing5: CGFloat = 20
    static let spacing6: CGFloat = 24
    static let spacing7: CGFloat = 28
    static let spacing8: CGFloat = 32
    static let spacing12: CGFloat = 48
    static let spacing16: CGFloat = 64
}

struct Styles: View {
    var body: some View {
        VStack(spacing: Spacing.spacing4) {
            Text("Header One")
                .font(Typography.HeaderOne.font)
                .foregroundColor(ColorScheme.onPrimary)
                .padding(Spacing.spacing8)
                .background(ColorScheme.primary)
                .cornerRadius(Dimensions.cornerRadius)
                .defaultShadow()
         

            Text("Header Two")
                .font(Typography.HeaderTwo.font)
                .foregroundColor(ColorScheme.variant)
                .padding(Spacing.spacing6)
                .background(ColorScheme.primary)
                .cornerRadius(Dimensions.cornerRadius)
                .defaultShadow()
               

            Text("Footer Text")
                .font(Typography.FooterText.font)
                .foregroundColor(ColorScheme.onSecondary)
                .padding(Spacing.spacing3)
                .background(ColorScheme.secondary)
                .cornerRadius(Dimensions.cornerRadius)
                .defaultShadow()
                

            Text("Normal Text")
                .font(Typography.NormalText.font)
                .foregroundColor(ColorScheme.onBackground)
                .padding(Spacing.spacing4)
                .background(ColorScheme.background)
                .cornerRadius(Dimensions.cornerRadius)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorScheme.background)
        .edgesIgnoringSafeArea(.all)
    }
}

struct Styles_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Styles()
        }
    }
}
