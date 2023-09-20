//
//  FindRecipeView.swift
//  RecipeManager
//
//  Created by Guido Roos on 11/09/2023.
//

import SwiftUI

//
//  RecipeOverviewView.swift
//  RecipeManager
//
//  Created by Guido Roos on 11/09/2023.
//

import SwiftUI

struct FindRecipeView: View {
    @State var meals: [Meal] = []
    @State private var selectedMeal: Meal? = nil
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    @Environment(\.managedObjectContext) private var viewContext
    let persistanceController = PersistenceController.shared

    func fetchRecipes(byName name: String) async {
        do {
            if APIClient.checkNetworkAvailability() {
                meals = []
                isLoading = true
                let mealResponse = try await RecipeAPI.getRecipeByName(name: name)
                meals = mealResponse.meals?.map { Meal(networkMeal: $0) } ?? []
                isLoading = false
            } else {
                alertMessage = "No network connection, cannot lookup recipes"
                showAlert = true
            }
        } catch {
            isLoading = false
            alertMessage = "An error occurred while fetching recipes."
            showAlert = true
        }
    }

    func saveMeal(meal: Meal) {
        Task {
            do {
                isLoading = true
                try await meal.saveMealToDatabase(context: viewContext, imageData: nil)

                isLoading = false
                alertMessage = "Save recipe succesful!"
                showAlert = true

            } catch {
                alertMessage = "Could not save recipe due to error"
                showAlert = true
            }
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                SearchBar(
                    isLoading: isLoading
                ) { terms in
                    Task {
                        await fetchRecipes(byName: terms)
                    }
                }
                .padding(.top, Spacing.spacing2)

                if meals.isEmpty && !isLoading {
                    Text("No recipes found")
                        .font(Typography.HeaderOne.font)
                        .foregroundColor(ColorScheme.onBackground)
                        .padding(.top, 200)
                } else {
                    if !isLoading {
                        Text("Found Recipes")
                            .font(Typography.HeaderTwo.font)
                            .foregroundColor(ColorScheme.onBackground)
                            .padding(.bottom, Spacing.spacing4)

                        ForEach(Array(meals.enumerated()), id: \.element) { index, meal in
                            Button(action: {
                                selectedMeal = meal
                            }) {
                                VStack(spacing: 0) {
                                    RecipeCardView(
                                        meal: meal,
                                        saveAction: { meal in
                                            saveMeal(meal: meal)
                                        }
                                    )
                                    .roundedCorner(index == 0 ? Dimensions.cornerRadius : 0, corners: [.topLeft, .topRight])
                                    .roundedCorner(index == meals.count - 1 ? Dimensions.cornerRadius : 0, corners: [.bottomLeft, .bottomRight])
                                    .defaultShadow()

                                    if index != meals.count - 1 {
                                        Divider()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .alert(
                alertMessage,
                isPresented: $showAlert
            ) {
                Button("OK", role: .cancel) {}
            }
            .overlay {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .tint(ColorScheme.onBackground)
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .padding(.horizontal, Spacing.spacing3)
            .padding(.vertical, Spacing.spacing2)
            .sheet(item: $selectedMeal) { meal in
                ViewRecipeView(meal: meal, isSaved: false)
                    .background(ColorScheme.background)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Empty toolbar item
                    Spacer()
                }
            }
        }
    }
}

struct SearchBar: View {
    var isLoading: Bool
    var onSearch: (String) -> Void
    @State var searchText: String = ""
    @FocusState private var isFieldFocused: Bool

    init(isLoading: Bool, onSearch: @escaping (String) -> Void) {
        self.onSearch = onSearch
        self.isLoading = isLoading
    }

    var body: some View {
        HStack {
            TextField("Type here", text: $searchText)
                .padding()
                .disableAutocorrection(true)
                .font(Typography.NormalText.font)
                .background(ColorScheme.textfield)
                .foregroundColor(ColorScheme.onBackground)
                .cornerRadius(Dimensions.textfieldRadius)
                .defaultShadow()
                .onSubmit {
                    onSearch(searchText)
                }
                .focused($isFieldFocused)
                .onAppear {
                    isFieldFocused = true
                }

            Button(action: {
                onSearch(searchText)
            }) {
                Text("Search")
                    .foregroundColor(ColorScheme.onSecondary)
                    .font(Typography.NormalText.font)
                    .padding()
                    .background(ColorScheme.secondary)
                    .cornerRadius(Dimensions.cornerRadius)
                    .defaultShadow()
            }
            .padding()
        }
    }
}

struct FindRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FindRecipeView()
                .navigationBarHidden(false)
                .accentColor(.white)
        }
    }
}
