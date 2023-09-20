//
//  ViewRecipeView.swift
//  RecipeManager
//
//  Created by Guido Roos on 15/09/2023.
//

import Foundation
import SwiftUI

struct ViewRecipeView: View {
    @State var meal: Meal
    let isSaved: Bool
    @State var isLoading = false

    let persistanceController = PersistenceController.shared
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) var meals: FetchedResults<DatabaseMeal>

    @Environment(\.dismiss) private var dismiss

    private func deleteMeal(meal: Meal) {
        let databaseMeal = meals.filter { $0.idMeal == meal.idMeal }.first
        if let databaseMeal = databaseMeal {
            Task {
                isLoading = true
                await viewContext.perform { viewContext.delete(databaseMeal) }
                try? persistanceController.saveContext()
                isLoading = false
            }
        }
    }

    init(
        meal: Meal = Meal.mock(),
        isSaved: Bool = true

    ) {
        self._meal = State(initialValue: meal)
        self.isSaved = isSaved
    }

    var body: some View {
        VStack {
            Text(meal.strMeal)
                .font(Typography.HeaderTwo.font)
                .foregroundColor(ColorScheme.onBackground)

            Text(meal.strArea)
                .font(Typography.NormalText.font)
                .foregroundColor(ColorScheme.onBackground)

            Text(meal.strCategory)
                .font(Typography.NormalText.font)
                .foregroundColor(ColorScheme.onBackground)

            ScrollView {
                LazyVStack {
                    StringItemListView(
                        items: meal.ingredients.zipWithStringList(meal.measures)
                    )

                    Divider()

                    StringItemListView(
                        items: meal.strInstructions,
                        font: Typography.FooterText.font,
                        showBullets: false
                    ).padding(.horizontal, Spacing.spacing2)
                }
                .padding(.horizontal, Spacing.spacing2)
            }
            if isSaved {
                Button(action: {
                    // Add your action here if needed
                }) {
                    NavigationLink(
                        destination: RecipeStepView(meal: meal)
                            .background(ColorScheme.background)
                    ) {
                        Text("Step by Step")
                            .frame(maxWidth: .infinity)

                            .foregroundColor(ColorScheme.onSecondary)
                            .font(Typography.NormalText.font)
                            .padding()
                            .background(ColorScheme.secondary)
                            .cornerRadius(Dimensions.cornerRadius)
                            .defaultShadow()
                    }
                }.padding(.all, Spacing.spacing4)
            }
        }
        .padding(.top, Spacing.spacing3)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // Empty toolbar item
                Spacer()
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: EditRecipeView(
                        meal: meal
                    )
                    .background(ColorScheme.background)

                ) {
                    Image(systemName: "pencil")
                        .foregroundColor(ColorScheme.onPrimary)
                }
                background(ColorScheme.background)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    deleteMeal(meal: meal)

                    dismiss()
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(ColorScheme.onPrimary)
                }
            }
        }
    }
}

struct ViewRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ViewRecipeView(
                meal: Meal.mock()
            )
        }
        .navigationBarHidden(false)
        .accentColor(.white)
    }
}
