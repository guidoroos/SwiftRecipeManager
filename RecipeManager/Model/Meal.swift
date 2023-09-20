//
//  Meal.swift
//  RecipeManager
//
//  Created by Guido Roos on 19/09/2023.
//

import Foundation
import CoreData

struct Meal: Codable, Identifiable, Hashable {
    var id: String { return idMeal }
    var idMeal: String
    var strMeal: String
    var strDrinkAlternate: String?
    var strCategory: String
    var strArea: String
    var strInstructions: [String]
    var strMealThumb: String?
    var strTags: String?
    var strYoutube: String?
    var ingredients: [String]
    var measures: [String]
    var strSource: String?
    var strImageSource: String?
    var strCreativeCommonsConfirmed: String?
    var dateModified: String?
    var imageData: Data?

    init(networkMeal: NetworkMeal) {
        self.idMeal = networkMeal.idMeal ?? UUID().uuidString
        self.strMeal = networkMeal.strMeal
        self.strDrinkAlternate = networkMeal.strDrinkAlternate
        self.strCategory = networkMeal.strCategory
        self.strArea = networkMeal.strArea
        self.strInstructions = networkMeal.strInstructions.splitStringByDotWithSpace()
        self.strMealThumb = networkMeal.strMealThumb
        self.strTags = networkMeal.strTags
        self.strYoutube = networkMeal.strYoutube
        self.strSource = networkMeal.strSource
        self.strImageSource = networkMeal.strImageSource
        self.strCreativeCommonsConfirmed = networkMeal.strCreativeCommonsConfirmed
        self.dateModified = networkMeal.dateModified
        self.imageData = nil

        self.ingredients = Meal.extractIngredients(from: networkMeal)
        self.measures = Meal.extractMeasures(from: networkMeal)
    }

    init(databaseMeal: DatabaseMeal) {
        self.idMeal = databaseMeal.idMeal ?? UUID().uuidString
        self.strMeal = databaseMeal.strMeal ?? ""
        self.strDrinkAlternate = databaseMeal.strDrinkAlternate
        self.strCategory = databaseMeal.strCategory ?? ""
        self.strArea = databaseMeal.strArea ?? ""
        self.strInstructions = databaseMeal.strInstructions as? [String] ?? []
        self.strMealThumb = databaseMeal.strMealThumb ?? ""
        self.strTags = databaseMeal.strTags
        self.strYoutube = databaseMeal.strYoutube ?? ""
        self.ingredients = databaseMeal.ingredients as? [String] ?? []
        self.measures = databaseMeal.measures as? [String] ?? []
        self.strSource = databaseMeal.strSource
        self.strImageSource = databaseMeal.strImageSource
        self.strCreativeCommonsConfirmed = databaseMeal.strCreativeCommonsConfirmed
        self.dateModified = databaseMeal.dateModified
        self.imageData = databaseMeal.imageData
 
    }

    init(
        idMeal: String?,
        strMeal: String,
        strDrinkAlternate: String?,
        strCategory: String,
        strArea: String,
        strInstructions: [String],
        strMealThumb: String,
        strTags: String?,
        strYoutube: String,
        ingredients: [String],
        measures: [String],
        strSource: String?,
        strImageSource: String?,
        strCreativeCommonsConfirmed: String?,
        dateModified: String?
    ) {
        self.idMeal = idMeal ?? UUID().uuidString
        self.strMeal = strMeal
        self.strDrinkAlternate = strDrinkAlternate
        self.strCategory = strCategory
        self.strArea = strArea
        self.strInstructions = strInstructions
        self.strMealThumb = strMealThumb
        self.strTags = strTags
        self.strYoutube = strYoutube
        self.ingredients = ingredients
        self.measures = measures
        self.strSource = strSource
        self.strImageSource = strImageSource
        self.strCreativeCommonsConfirmed = strCreativeCommonsConfirmed
        self.dateModified = dateModified
    }
}

extension Meal {
    static func empty() -> Meal {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        
        return Meal (
        idMeal: UUID().uuidString,
        strMeal: "",
        strDrinkAlternate: nil,
        strCategory: "",
        strArea: "",
        strInstructions: [],
        strMealThumb: "",
        strTags: nil,
        strYoutube: "",
        ingredients: [],
        measures: [],
        strSource: nil,
        strImageSource: nil,
        strCreativeCommonsConfirmed: nil,
        dateModified: dateFormatter.string(from: currentDate)
        )
    }

    func saveMealToDatabase(context: NSManagedObjectContext, imageData: Data?) async throws {
        let databaseMeal = DatabaseMeal(context:context)
        databaseMeal.idMeal = idMeal
        databaseMeal.strMeal = strMeal
        databaseMeal.strDrinkAlternate = strDrinkAlternate
        databaseMeal.strCategory = strCategory
        databaseMeal.strArea = strArea
        databaseMeal.strInstructions = strInstructions as NSObject
        databaseMeal.strMealThumb = strMealThumb
        databaseMeal.strTags = strTags
        databaseMeal.strYoutube = strYoutube
        databaseMeal.ingredients = ingredients as NSObject
        databaseMeal.measures = measures as NSObject
        databaseMeal.strSource = strSource
        databaseMeal.strImageSource = strImageSource
        databaseMeal.strCreativeCommonsConfirmed = strCreativeCommonsConfirmed
        databaseMeal.dateModified = dateModified
        databaseMeal.imageData = imageData
        try context.save()
    }
    
    func updateMealToDatabase(context: NSManagedObjectContext, imageData: Data?, databaseMeal:DatabaseMeal) async throws {
        databaseMeal.strMeal = strMeal
        databaseMeal.strDrinkAlternate = strDrinkAlternate
        databaseMeal.strCategory = strCategory
        databaseMeal.strArea = strArea
        databaseMeal.strInstructions = strInstructions as NSObject
        databaseMeal.strMealThumb = strMealThumb
        databaseMeal.strTags = strTags
        databaseMeal.strYoutube = strYoutube
        databaseMeal.ingredients = ingredients as NSObject
        databaseMeal.measures = measures as NSObject
        databaseMeal.strSource = strSource
        databaseMeal.strImageSource = strImageSource
        databaseMeal.strCreativeCommonsConfirmed = strCreativeCommonsConfirmed
        databaseMeal.dateModified = dateModified
        databaseMeal.imageData = imageData
        try context.save()
    }
}
