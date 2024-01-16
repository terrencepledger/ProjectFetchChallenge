//
//  Dessert.swift
//  FetchChallenge
//
//  Created by Terrence Pledger II on 1/14/24.
//

import Foundation

typealias MealDetailsResponseJson = Dictionary<String, Any>

struct MealsResponse: Codable {
    var meals: [Meal]
}

struct MealDetailResponse: Codable {
    var rawResponse: [MealDetails]
    var mealDetails: MealDetails {
        rawResponse.first!
    }
    
    enum CodingKeys: String, CodingKey {
        case rawResponse = "meals"
    }
}

struct Meal: Codable, Identifiable {
    var id: String
    var name: String
    
    private var rawImageLink: String
    var imageURL: URL? {
        URL(string: rawImageLink)
    }

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case rawImageLink = "strMealThumb"
    }
}

struct MealDetails: Codable, Identifiable {
    var id: String
    var name: String
    var instructions: String
    
    var ingredients: [String] = []

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
    }
}
