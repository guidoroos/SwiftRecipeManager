//
//  MealExtensions.swift
//  RecipeManager
//
//  Created by Guido Roos on 19/09/2023.
//

import Foundation

extension Meal {
    static func mock() -> Meal {
        return Meal(
            idMeal: "1",
            strMeal: "Mock Meal 1",
            strDrinkAlternate: nil,
            strCategory: "Mock Category 1",
            strArea: "Mock Area 1",
            strInstructions: ["Mock Instructions 1","Mock Instructions 1"],
            strMealThumb: "https://example.com/mock-image-1.jpg",
            strTags: "Mock Tags 1",
            strYoutube: "https://www.youtube.com/mock-video-1",
            ingredients: ["Ingredient 1", "Ingredient 2"],
            measures: ["Measure 1", "Measure 2"],
            strSource: nil,
            strImageSource: nil,
            strCreativeCommonsConfirmed: nil,
            dateModified: nil
        )
    }
                    

    static func mocks() -> [Meal] {
        return [
            Meal(
                idMeal: "1",
                strMeal: "Mock Meal 1",
                strDrinkAlternate: nil,
                strCategory: "Mock Category 1",
                strArea: "Mock Area 1",
                strInstructions: ["Mock Instructions 1","Mock Instructions 1"],
                strMealThumb: "https://example.com/mock-image-1.jpg",
                strTags: "Mock Tags 1",
                strYoutube: "https://www.youtube.com/mock-video-1",
                ingredients: ["Ingredient 1", "Ingredient 2"],
                measures: ["Measure 1", "Measure 2"],
                strSource: nil,
                strImageSource: nil,
                strCreativeCommonsConfirmed: nil,
                dateModified: nil
            ),
            Meal(
                idMeal: "2",
                strMeal: "Mock Meal 2",
                strDrinkAlternate: nil,
                strCategory: "Mock Category 2",
                strArea: "Mock Area 2",
                strInstructions: ["Mock Instructions 2","Mock Instructions 2"],
                strMealThumb: "https://example.com/mock-image-2.jpg",
                strTags: "Mock Tags 2",
                strYoutube: "https://www.youtube.com/mock-video-2",
                ingredients: ["Ingredient 1", "Ingredient 2"],
                measures: ["Measure 1", "Measure 2"],
                strSource: nil,
                strImageSource: nil,
                strCreativeCommonsConfirmed: nil,
                dateModified: nil
            ),
            Meal(
                idMeal: "3",
                strMeal: "Mock Meal 3",
                strDrinkAlternate: nil,
                strCategory: "Mock Category 3",
                strArea: "Mock Area 3",
                strInstructions: ["Mock Instructions 3","Mock Instructions 3"],
                strMealThumb: "https://example.com/mock-image-3.jpg",
                strTags: "Mock Tags 3",
                strYoutube: "https://www.youtube.com/mock-video-3",
                ingredients: ["Ingredient 1", "Ingredient 2"],
                measures: ["Measure 1", "Measure 2"],
                strSource: nil,
                strImageSource: nil,
                strCreativeCommonsConfirmed: nil,
                dateModified: nil
            )
        ]
    }
}


extension Meal {
    static func extractIngredients(from meal: NetworkMeal) -> [String] {
        var nonEmptyIngredients: [String] = []

        for index in 1...20 {
            if let ingredient = getValue(from: meal, key: "strIngredient", index: index), !ingredient.isEmpty {
                nonEmptyIngredients.append(ingredient)
            }
        }

        let sortedIngredients = sortValues(nonEmptyIngredients)

        return sortedIngredients
    }

    static func extractMeasures(from meal: NetworkMeal) -> [String] {
        var nonEmptyMeasures: [String] = []

        for index in 1...20 {
            if let measure = getValue(from: meal, key: "strMeasure", index: index), !measure.isEmpty {
                nonEmptyMeasures.append(measure)
            }
        }

        let sortedMeasures = sortValues(nonEmptyMeasures)

        return sortedMeasures
    }

    static func getValue(from meal: NetworkMeal, key: String, index: Int) -> String? {
        let mirror = Mirror(reflecting: meal)
        let ingredientKey = "\(key)\(index)"

        for child in mirror.children {
            if let label = child.label, label == ingredientKey {
                if let value = child.value as? String {
                    return value
                }
            }
        }

        return nil
    }

    private static func sortValues(_ values: [String]) -> [String] {
        return values.sorted { value1, value2 -> Bool in
            let number1 = extractNumber(from: value1)
            let number2 = extractNumber(from: value2)
            return number1 < number2
        }
    }

    static func extractNumber(from value: String) -> Int {
        guard let numberRange = value.rangeOfCharacter(from: .decimalDigits, options: .backwards),
              let number = Int(value[numberRange])
        else {
            return 0
        }
        return number
    }
}
