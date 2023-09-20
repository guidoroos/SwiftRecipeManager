//
//  ContentView.swift
//  RecipeManager
//
//  Created by Guido Roos on 08/09/2023.
//

import CoreData
import SwiftUI

enum Page {
    case recipeOverview
    case findRecipe
    case editRecipe
}

struct ContentView: View {
    @State private var selectedTab: Page = .recipeOverview

    var body: some View {
        TabBarView(selectedTab: $selectedTab)
        
    }
}

struct TabBarView: View {
    @Binding var selectedTab: Page

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                RecipeOverviewView()
                    .background(ColorScheme.onPrimary)
            }.tabItem {
                Button(action: {
                    self.selectedTab = .recipeOverview
                }) {
                    Image(systemName: "house")
                }
            }
            .toolbarBackground(ColorScheme.primary, for: .tabBar)

            NavigationView {
                FindRecipeView()
                    .background(ColorScheme.onPrimary)
            }.tabItem {
                Button(action: {
                    self.selectedTab = .findRecipe
                }) {
                    Image(systemName: "magnifyingglass")
                }
            }.toolbarBackground(ColorScheme.primary, for: .tabBar)

            NavigationView {
                EditRecipeView()
                    .background(ColorScheme.onPrimary)
            }
            .tabItem {
                Button(action: {
                    self.selectedTab = .editRecipe
                }) {
                    Image(systemName: "plus.circle")
                }
            }.toolbarBackground(ColorScheme.primary, for: .tabBar)
        }
        .accentColor(ColorScheme.variant)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
