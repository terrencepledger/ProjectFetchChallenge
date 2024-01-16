//
//  MealDetailsView.swift
//  FetchChallenge
//
//  Created by Terrence Pledger II on 1/14/24.
//

import SwiftUI

struct MealDetailsView: View {
    var meal: Meal
    @StateObject var vm = MealDetailsViewModel()
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ScrollView {
            HStack {
                AsyncImage(
                    url: meal.imageURL,
                    content: { image in
                        image.image?.resizable()
                    }
                ).frame(width: 75, height: 75).padding()
                Text(vm.details?.name ?? "")
            }
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(vm.details?.ingredients ?? [""], id: \.self) { ingredient in
                Text(ingredient)
                }
            }
            Text(vm.details?.instructions ?? "")
        }
        .padding()
        .task {
            await vm.getMealDetails(for: meal)
        }
    }
}

#Preview {
    MealListView()
}
