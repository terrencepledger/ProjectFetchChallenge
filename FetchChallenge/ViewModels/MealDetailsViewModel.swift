//
//  MealDetailsViewModel.swift
//  FetchChallenge
//
//  Created by Terrence Pledger II on 1/14/24.
//

import Foundation

@MainActor
class MealDetailsViewModel: ObservableObject {
    @Published var details: MealDetails?

    func getMealDetails(for meal: Meal) async {
        guard let details = try? await MealService().getMealDetails(meal: meal) else {
            return
        }
        
        self.details = details
    }
}
