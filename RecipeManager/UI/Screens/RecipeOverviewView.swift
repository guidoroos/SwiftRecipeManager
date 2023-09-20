//
//  RecipeOverviewView.swift
//  RecipeManager
//
//  Created by Guido Roos on 11/09/2023.
//

import SwiftUI

struct RecipeOverviewView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) var meals: FetchedResults<DatabaseMeal>

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                Text("Saved Recipes")
                    .font(Typography.HeaderTwo.font)
                    .foregroundColor(ColorScheme.onBackground)
                    .padding(.bottom, Spacing.spacing4)

                if meals.isEmpty {
                    HStack(spacing: Spacing.spacing2) {
                        NavigationLink(
                            destination: EditRecipeView()
                                .background(ColorScheme.background)
                        ) {
                            Text("Create a recipe")
                                .foregroundColor(ColorScheme.onSecondary)
                                .font(Typography.NormalText.font)
                                .padding()
                                .background(ColorScheme.secondary)
                                .cornerRadius(Dimensions.cornerRadius)
                                .defaultShadow()
                        }
                        .padding()
                    }

                    NavigationLink(
                        destination: FindRecipeView()
                            .background(ColorScheme.background)
                    ) {
                        Text("Search in mealDB")
                            .foregroundColor(ColorScheme.onSecondary)
                            .font(Typography.NormalText.font)
                            .padding()
                            .background(ColorScheme.secondary)
                            .cornerRadius(Dimensions.cornerRadius)
                            .defaultShadow()
                    }
                    .padding()

                } else {
                    ForEach(Array(meals.enumerated()), id: \.element) { index, dbMeal in
                        let meal = Meal(databaseMeal: dbMeal)

                        NavigationLink(
                            destination: ViewRecipeView(
                                meal: meal
                            )
                            .background(ColorScheme.background)
                        ) {
                            RecipeCardView(meal: meal)
                                .roundedCorner(index == 0 ? Dimensions.cornerRadius : 0, corners: [.topLeft, .topRight])
                                .roundedCorner(index == meals.count - 1 ? Dimensions.cornerRadius : 0, corners: [.bottomLeft, .bottomRight])
                        }

                        if index != meals.count - 1 {
                            Divider()
                        }
                    }
                }
            }
            .padding(.horizontal, Spacing.spacing3)
            .padding(.vertical, Spacing.spacing2)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // Empty toolbar item
                Spacer()
            }
        }
    }
}

struct RecipeOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeOverviewView()
                .navigationBarHidden(false)

        }.accentColor(.white)
    }
}
