//
//  EditRecipeView.swift
//  RecipeManager
//
//  Created by Guido Roos on 11/09/2023.
//

import SwiftUI

struct RecipeStepView: View {
    @State var meal: Meal

    @State private var selectedStepPosition = 0
    @State private var offset: CGFloat = 0

    init(
        meal: Meal = Meal.mock()
    ) {
        self._meal = State(initialValue: meal)
    }

    var body: some View {
        VStack {
            Text(meal.strMeal)
                .font(Typography.HeaderTwo.font)
                .foregroundColor(ColorScheme.onBackground)

            HStack {
                ScrollView {
                    StringItemListView(
                        items: meal.ingredients.zipWithStringList(meal.measures)
                    )
                    .padding(.horizontal, Spacing.spacing2)

                    Spacer()
                }
            }

            Divider()

            VStack(spacing: Spacing.spacing6) {
                HStack(alignment: .top) {
                    if selectedStepPosition < meal.strInstructions.count && selectedStepPosition >= 0  {
                        Text(meal.strInstructions[selectedStepPosition])
                            .font(Typography.HeaderTwo.font)
                    }
                }

                HStack {
                    if selectedStepPosition != 0 {
                        Button(action: {
                            selectedStepPosition -= 1
                        }) {
                            Image(systemName: "chevron.backward")
                                .font(.title)
                                .foregroundColor(ColorScheme.primary)
                        }
                    }

                    Spacer()
                    if selectedStepPosition < meal.strInstructions.count - 2 {
                        Button(action: {
                            selectedStepPosition += 1

                        }) {
                            Image(systemName: "chevron.forward")
                                .font(.title)
                                .foregroundColor(ColorScheme.primary)
                        }
                    }
                }
                .padding(.bottom, Spacing.spacing2)
                .padding(.horizontal, Spacing.spacing2)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    offset = value.translation.width
                }
                .onEnded { value in
                    if value.translation.width < 0 {
                        if selectedStepPosition != 0 {
                            selectedStepPosition -= 1
                        }
                    } else if value.translation.width > 0 {
                        if selectedStepPosition < meal.strInstructions.count - 1 {
                            selectedStepPosition += 1
                        }
                    }
                    offset = 0
                }
        )
        .padding(.horizontal, Spacing.spacing3)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // Empty toolbar item
                Spacer()
            }
        }
    }
}

struct StringItemListView: View {
    var items: [String]
    let font: Font
    let showBullets: Bool

    init(
        items: [String],
        font: Font = Typography.NormalText.font,
        showBullets: Bool = true
    ) {
        self.items = items
        self.font = font
        self.showBullets = showBullets
    }

    var body: some View {
        LazyVStack(alignment: .leading, spacing: Spacing.spacing1) {
            ForEach(Array(items.enumerated()), id: \.element) { _, item in
                HStack {
                    if showBullets {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 7, height: 7)
                            .foregroundColor(ColorScheme.secondary)
                    }
                    Text(item)
                        .font(font)
                        .foregroundColor(ColorScheme.onBackground)
                }
            }
        }
    }
}

struct RecipeStepView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeStepView(meal: Meal.mock())
        }
        .navigationBarHidden(false)
        .accentColor(.white)
    }
}
