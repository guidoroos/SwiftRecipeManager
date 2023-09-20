//
//  RecipeAPI.swift
//  RecipeManager
//
//  Created by Guido Roos on 08/09/2023.
//

import Foundation

class RecipeAPI: APIClient {
    enum Endpoint {
        case recipeByName(name: String)
        case detailsForRecipe(id: String)
        case randomRecipe
        case recipeByIngredient(ingredient: String)
        case recipeByLetter(letter: Character)

        var stringValue: String {
            switch self {
            case let .recipeByName(name):
                return "\(baseURL)search.php?s=\(name)"
            case let .detailsForRecipe(id):
                return "\(baseURL)lookup.php?i=\(id)"
            case .randomRecipe:
                return "\(baseURL)random.php"
            case let .recipeByIngredient(ingredient):
                return "\(baseURL)filter.php?i=\(ingredient)"
            case let .recipeByLetter(letter):
                return "\(baseURL)search.php?f=a\(letter)"
            }
        }
    }

    class func getRecipeByName(name: String) async throws -> MealResponse {
        return try await taskForGetRequest(url: getUrl(
            urlString: Endpoint.recipeByName(name: name)
                .stringValue)
        )
    }
}
