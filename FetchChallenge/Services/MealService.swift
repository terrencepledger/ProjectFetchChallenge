//
//  RecipesAPI.swift
//  FetchChallenge
//
//  Created by Terrence Pledger II on 1/14/24.
//

import Foundation

enum MealServiceErrors: Error {
    case serverError, decodingError, invalidURL
}

struct MealService {
    func getMeals() async throws -> [Meal] {
        guard let getMealsURL = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            throw MealServiceErrors.invalidURL
        }

        let (data, urlResponse) = try await URLSession.shared.data(from: getMealsURL)
        guard let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MealServiceErrors.serverError
        }

        if let mealListResponse = try? JSONDecoder().decode(MealsResponse.self, from: data) {
            return mealListResponse.meals
        } else {
            throw MealServiceErrors.decodingError
        }
    }
    
    func getMealDetails(meal: Meal) async throws -> MealDetails {
        guard let getMealDetailsURL = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(meal.id)") else {
            throw MealServiceErrors.invalidURL
        }

        let (data, urlResponse) = try await URLSession.shared.data(from: getMealDetailsURL)
        guard let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MealServiceErrors.serverError
        }

        if let mealDetailsResponse = try? JSONDecoder().decode(MealDetailResponse.self, from: data) {
            return try addIngredients(for: mealDetailsResponse.mealDetails, from: data)
        } else {
            throw MealServiceErrors.decodingError
        }
    }
    
    private func addIngredients(for details: MealDetails, from data: Data) throws -> MealDetails {
        var newMealDetails = details

        if let rawJson = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: [MealDetailsResponseJson]], let mealDetailsJson = rawJson.first?.value.first {
            for i in 1...20 {
                guard let ingredient = mealDetailsJson["strIngredient\(String(i))"] as? String, !ingredient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    continue
                }
                guard let measurement = mealDetailsJson["strMeasure\(String(i))"] as? String, !measurement.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    continue
                }

                let completeIngredient = "\(measurement) \(ingredient)"
                newMealDetails.ingredients.append(completeIngredient)
            }
        } else {
            throw MealServiceErrors.decodingError
        }
        
        return newMealDetails
    }
}
