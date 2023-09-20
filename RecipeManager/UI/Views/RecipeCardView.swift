//
//  RecipeCardView.swift
//  RecipeManager
//
//  Created by Guido Roos on 12/09/2023.
//

import SwiftUI

struct RecipeCardView: View {
    let meal: Meal
    let saveAction: ((Meal) -> Void)?
    
    init(
        meal: Meal,
        saveAction: ( (Meal) -> Void)? = nil
    ) {
        self.meal = meal
        self.saveAction = saveAction
    }
    
    var body: some View {
        let url = URL(string: meal.strMealThumb ?? "")
        
        HStack(spacing: Spacing.spacing3) {
            RecipeImage(
                url: url,
                savedImage: meal.imageData,
                stateColor: ColorScheme.onSecondary
            )
            .padding(.leading, Spacing.spacing3)
            
          
            VStack(alignment: .leading, spacing: 0) {
                Text(meal.strMeal)
                    .font(Typography.NormalText.font)
                    .foregroundColor(ColorScheme.onSecondary)
                    .multilineTextAlignment(.leading)
                HStack {
                    Text("Origin: ")
                        .font(Typography.FooterText.font)
                        .foregroundColor(ColorScheme.variant)
                    Text(meal.strArea )
                        .font(Typography.FooterText.font)
                        .foregroundColor(ColorScheme.onSecondary)
                }
                HStack {
                    Text("Category: ")
                        .font(Typography.FooterText.font)
                        .foregroundColor(ColorScheme.variant)
                    Text(meal.strCategory )
                        .font(Typography.FooterText.font)
                        .foregroundColor(ColorScheme.onSecondary)
                }
            }
            .padding()
            .foregroundColor(ColorScheme.onSecondary)
    
            Spacer()
            
            if let saveAction = saveAction {
                Button(action: {
                    saveAction(meal)
                }) {
                    Text("Save")
                        .foregroundColor(ColorScheme.onPrimary)
                        .font(Typography.NormalText.font)
                        .padding()
                        
                        .background(ColorScheme.primary)
                        .cornerRadius(Dimensions.cornerRadius)
                        .defaultShadow()
                }
                .padding(.trailing, Spacing.spacing4)
            }
        }
        .background(ColorScheme.secondary)
    }

}

struct RecipeCardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeCardView(meal: Meal.mock())
                .frame(width:.infinity)
        }
        
        NavigationView {
            RecipeCardView(
                meal: Meal.mock(),
                saveAction: {_ in }
            )
                .frame(width:.infinity)
        }
    }
}
