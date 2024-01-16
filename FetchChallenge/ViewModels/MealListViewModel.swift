//
//  MealViewModel.swift
//  FetchChallenge
//
//  Created by Terrence Pledger II on 1/14/24.
//

import Foundation

@MainActor
class MealListViewModel: ObservableObject {
    @Published var meals: [Meal] = []

    func getMeals() async {
        guard let meals = try? await MealService().getMeals() else {
            return
        }
        
        self.meals = meals
    }
}
