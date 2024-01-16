//
//  MealsView.swift
//  FetchChallenge
//
//  Created by Terrence Pledger II on 1/14/24.
//

import SwiftUI

struct MealListView: View {
    @StateObject var vm = MealListViewModel()
    
    var body: some View {
        NavigationView{
            List{
                ForEach(vm.meals.sorted{ $0.name < $1.name }) { meal in
                    VStack{
                        NavigationLink(destination: MealDetailsView(meal: meal)) {
                            if let imgURL = meal.imageURL {
                                HStack {
                                    AsyncImage(
                                        url: imgURL,
                                        content: { image in
                                            image.image?.resizable()
                                        }
                                    ).frame(width: 50, height: 50)
                                    Text(meal.name)
                                }.padding()
                            } else {
                                Text(meal.name)
                            }
                        }
                    }
                }
            }
            .padding()
            .task {
                await vm.getMeals()
            }
        }
    }
}

#Preview {
    MealListView()
}
