//
//  EditRecipeView.swift
//  RecipeManager
//
//  Created by Guido Roos on 11/09/2023.
//

import SwiftUI

struct EditRecipeView: View {
    @State var meal: Meal
    let oldMeal: Meal

    @State private var selectedIngredientPosition = -1
    @State private var selectedStepPosition = -1

    @State private var editIngredientText = ""
    @State private var editMeasureText = ""
    @State private var editStepText = ""

    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var shouldDismiss = false
    @State private var showImageAlert = false
    @State private var isPhotoChanged = false

    @State private var image: UIImage?
    @State private var showImagePicker = false

    @State private var imageType: ImagePickerView.SourceType = .camera

    let persistanceController = PersistenceController.shared
    @FetchRequest(sortDescriptors: []) var meals: FetchedResults<DatabaseMeal>

    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext

    func saveMeal(meal: Meal) {
        Task {
            do {
                isLoading = true
                
                let databaseMeal = meals.filter { $0.idMeal == meal.idMeal }.first
                if let databaseMeal = databaseMeal {
                    try await meal.updateMealToDatabase(context: viewContext, imageData: image?.pngData(), databaseMeal: databaseMeal)
                    
                    try? persistanceController.saveContext()
                } else {
                    try await meal.saveMealToDatabase(context: viewContext, imageData: image?.pngData())
                    try? persistanceController.saveContext()
                }

                isLoading = false
                alertMessage = "Save recipe successful!"
                showAlert = true
                shouldDismiss = true

            } catch {
                alertMessage = "Could not save recipe due to an error"
                showAlert = true
            }
        }
    }

    init(
        meal: Meal = Meal.empty()
    ) {
        self._meal = State(initialValue: meal)
        self.oldMeal = meal
    }

    var body: some View {
        let url = URL(string: meal.strMealThumb ?? "")

        VStack(spacing: 0) {
            HStack(spacing: 0) {
                TextField("Title", text: $meal.strMeal)
                    .font(Typography.HeaderTwo.font)
                    .foregroundColor(ColorScheme.onBackground)
                    .padding(.leading, Spacing.spacing3)
                    .padding(.top, Spacing.spacing3)

                Spacer()

                Button(action: {
                    showImageAlert = true
                }) {
                    RecipeImage(
                        url: url,
                        savedImage: meal.imageData,
                        stateColor: ColorScheme.onBackground
                    )
                    .padding(.trailing, Spacing.spacing3)
                }
            }.padding(.top, Spacing.spacing2)

            CustomTextField(placeholder: Text("Area"), text: $meal.strArea)
                .font(Typography.NormalText.font)
                .disableAutocorrection(true)
                .background(ColorScheme.textfield)
                .foregroundColor(ColorScheme.onBackground)
                .cornerRadius(Dimensions.textfieldRadius)
                .padding(.vertical, Spacing.spacing1)
                .padding(.horizontal, Spacing.spacing2)
                .defaultShadow()

            CustomTextField(placeholder: Text("Category"), text: $meal.strCategory)
                .font(Typography.NormalText.font)
                .disableAutocorrection(true)
                .background(ColorScheme.textfield)
                .foregroundColor(ColorScheme.onBackground)
                .cornerRadius(Dimensions.textfieldRadius)
                .padding(.vertical, Spacing.spacing1)
                .padding(.horizontal, Spacing.spacing2)
                .defaultShadow()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: Spacing.spacing2) {
                    EditIngredientView(
                        firstText: $editIngredientText,
                        secondText: $editMeasureText,
                        selectedPosition: $selectedIngredientPosition,
                        confirmAction: { ingredient, measure in
                            if selectedIngredientPosition == -1 {
                                self.meal.ingredients.append(ingredient)
                                self.meal.measures.append(measure)
                            } else {
                                self.meal.ingredients[selectedIngredientPosition] = ingredient
                                self.meal.measures[selectedIngredientPosition] = measure
                                selectedIngredientPosition = -1
                            }
                            self.editIngredientText = ""
                            self.editMeasureText = ""
                        },
                        deleteAction: {
                            self.meal.ingredients.remove(at: selectedIngredientPosition)
                            self.meal.measures.remove(at: selectedIngredientPosition)

                            self.editIngredientText = ""
                            self.editMeasureText = ""
                            selectedIngredientPosition = -1
                        }
                    )

                    BulletListView(
                        items: meal.ingredients.zipWithStringList(meal.measures),
                        selectedPosition: $selectedIngredientPosition,
                        onDeleteAtPosition: { position in
                            self.meal.ingredients.remove(at: position)
                            self.selectedIngredientPosition = -1
                        },
                        onSelectPosition: { position in
                            self.selectedIngredientPosition = position
                            self.editIngredientText = self.meal.ingredients[position]
                            self.editMeasureText = self.meal.measures[position]
                        },
                        onMoveItem: { from, to in
                            guard from != to else {
                                return
                            }
                            let ingredient = self.meal.ingredients.remove(at: from)
                            self.meal.ingredients.insert(ingredient, at: to)

                            let measure = self.meal.measures.remove(at: from)
                            self.meal.measures.insert(measure, at: to)

                            self.selectedIngredientPosition = -1
                        }
                    ).padding(.horizontal, Spacing.spacing2)

                    Divider()

                    EditStepView(
                        text: $editStepText,
                        selectedPosition: $selectedStepPosition,
                        confirmAction: { step in
                            if selectedStepPosition == -1 {
                                self.meal.strInstructions.append(step)
                            } else {
                                self.meal.strInstructions[selectedStepPosition] = step
                                selectedStepPosition = -1
                            }
                            self.editStepText = ""
                        }, deleteAction: {
                            self.meal.strInstructions.remove(at: selectedStepPosition)
                            selectedIngredientPosition = -1
                            self.editStepText = ""
                        }
                    )

                    BulletListView(
                        items: meal.strInstructions,
                        font: Typography.FooterText.font,
                        showBullet: false,
                        selectedPosition: $selectedStepPosition,
                        onDeleteAtPosition: { position in
                            self.meal.strInstructions.remove(at: position)
                            self.selectedStepPosition = -1
                        },
                        onSelectPosition: { position in
                            self.selectedStepPosition = position
                            self.editStepText = self.meal.strInstructions[position]
                        }
                    ) { from, to in
                        guard from != to else {
                            return
                        }
                        let step = self.meal.strInstructions.remove(at: from)
                        self.meal.strInstructions.insert(step, at: to)

                        self.selectedStepPosition = -1
                        self.editStepText = ""
                    }
                    .padding(.horizontal, Spacing.spacing2)
                }
                .padding(.all, Spacing.spacing2)
                .sheet(isPresented: $showImagePicker) {
                    ImagePickerView(image: $image, sourceType: imageType)
                }
                .onChange(of: image) { _ in
                    meal.imageData = image?.pngData()
                    isPhotoChanged = true
                }
                .alert(
                    alertMessage,
                    isPresented: $showAlert
                ) {
                    Button("OK", role: .cancel) {
                        if shouldDismiss { dismiss() }
                    }
                }
                .alert(isPresented: $showImageAlert) {
                    Alert(title: Text("Choose Image Source"), message: nil, primaryButton: .default(Text("Take Photo"), action: {
                        imageType = .camera
                        showImagePicker = true
                    }), secondaryButton: .default(Text("Select from Library"), action: {
                        imageType = .photoLibrary
                        showImagePicker = true
                    }))
                }
                .overlay {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .tint(ColorScheme.onBackground)
                            .edgesIgnoringSafeArea(.all)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        // Empty toolbar item
                        Spacer()
                    }

                    if self.meal != self.oldMeal || isPhotoChanged {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                saveMeal(meal: meal)

                            }) {
                                Image(systemName: "square.and.arrow.down")
                                    .foregroundColor(ColorScheme.onPrimary)
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                self.meal = oldMeal
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(ColorScheme.onPrimary)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct BulletListView: View {
    var items: [String]
    let font: Font
    let onDeleteAtPosition: (Int) -> Void
    let onSelectPosition: (Int) -> Void
    let onMoveItem: (Int, Int) -> Void
    let showBullet: Bool
    @Binding var selectedPosition: Int
    @State private var dragOffset: CGFloat = 0

    init(
        items: [String],
        font: Font = Typography.NormalText.font,
        showBullet: Bool = true,
        selectedPosition: Binding<Int>,
        onDeleteAtPosition: @escaping (Int) -> Void,
        onSelectPosition: @escaping (Int) -> Void,
        onMoveItem: @escaping (Int, Int) -> Void
    ) {
        self.items = items
        self.font = font
        self._selectedPosition = selectedPosition
        self.onDeleteAtPosition = onDeleteAtPosition
        self.onSelectPosition = onSelectPosition
        self.onMoveItem = onMoveItem
        self.showBullet = showBullet
    }

    var body: some View {
        LazyVStack(alignment: .leading, spacing: Spacing.spacing1) {
            ForEach(Array(items.enumerated()), id: \.element) { index, item in
                HStack {
                    if showBullet {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 7, height: 7)
                            .foregroundColor(ColorScheme.secondary)
                    }
                    Text(item)
                        .font(font)
                        .foregroundColor(index == selectedPosition ? Color.orange : ColorScheme.onBackground)

                    HStack(spacing: Spacing.spacing1) {
                        Button(action: {
                            onSelectPosition(index)
                        }) {
                            Image(systemName: "pencil.circle")
                                .foregroundColor(ColorScheme.secondary)
                                .imageScale(.medium)
                        }

                        Button(action: {
                            onDeleteAtPosition(index)
                        }) {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                                .imageScale(.medium)
                        }
                    }
                }.gesture(
                    SimultaneousGesture(
                        LongPressGesture(minimumDuration: 1000),
                        DragGesture(coordinateSpace: .global)
                            .onEnded { value in
                                let translation = value.translation.height
                                let threshold = CGFloat(1)

                                if translation > threshold {
                                    // Swipe down
                                    withAnimation {
                                        onMoveItem(index, index + 1)
                                    }
                                } else if translation < -threshold {
                                    // Swipe up
                                    withAnimation {
                                        onMoveItem(index, index - 1)
                                    }
                                }
                            }
                    )
                )
            }
        }
    }
}

struct EditStepView: View {
    @Binding private var text: String
    var confirmAction: (String) -> Void
    var deleteAction: () -> Void
    @Binding var selectedPosition: Int

    init(
        text: Binding<String>,
        selectedPosition: Binding<Int>,
        confirmAction: @escaping (String) -> Void,
        deleteAction: @escaping () -> Void

    ) {
        self._text = text
        self.confirmAction = confirmAction
        self.deleteAction = deleteAction
        self._selectedPosition = selectedPosition
    }

    var body: some View {
        HStack {
            CustomTextField(placeholder: Text("Enter step"), text: $text)
                .disableAutocorrection(true)
                .font(Typography.NormalText.font)
                .background(ColorScheme.textfield)
                .foregroundColor(ColorScheme.onBackground)
                .cornerRadius(Dimensions.textfieldRadius)

                .defaultShadow()

            Button(action: {
                confirmAction(text)
                text = ""
            }) {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green)
                    .imageScale(.large)
            }

            Button(action: {
                text = ""

                if selectedPosition != -1 {
                    deleteAction()
                }
            }) {
                Image(systemName: "xmark.circle")
                    .foregroundColor(.red)
                    .imageScale(.large)
            }
        }
        .padding()
    }
}

struct EditIngredientView: View {
    @Binding private var firstText: String
    @Binding private var secondText: String
    var confirmAction: (String, String) -> Void
    var deleteAction: () -> Void
    @Binding var selectedPosition: Int

    init(
        firstText: Binding<String>,
        secondText: Binding<String>,
        selectedPosition: Binding<Int>,
        confirmAction: @escaping (String, String) -> Void,
        deleteAction: @escaping () -> Void

    ) {
        self._firstText = firstText
        self._secondText = secondText
        self.confirmAction = confirmAction
        self.deleteAction = deleteAction
        self._selectedPosition = selectedPosition
    }

    var body: some View {
        HStack {
            CustomTextField(placeholder: Text("Enter ingredient"), text: $firstText)
                .font(Typography.NormalText.font)
                .disableAutocorrection(true)
                .background(ColorScheme.textfield)
                .foregroundColor(ColorScheme.onBackground)
                .cornerRadius(Dimensions.textfieldRadius)
                .defaultShadow()

            CustomTextField(placeholder: Text("Enter measure"), text: $secondText)
                .font(Typography.NormalText.font)
                .disableAutocorrection(true)
                .background(ColorScheme.textfield)
                .foregroundColor(ColorScheme.onBackground)
                .cornerRadius(Dimensions.textfieldRadius)
                .defaultShadow()

            Button(action: {
                confirmAction(firstText, secondText)
                firstText = ""
                secondText = ""
            }) {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green)
                    .imageScale(.large)
            }

            Button(action: {
                firstText = ""
                secondText = ""

                if selectedPosition != -1 {
                    deleteAction()
                }
            }) {
                Image(systemName: "xmark.circle")
                    .foregroundColor(.red)
                    .imageScale(.large)
            }
        }
        .padding()
    }
}

struct EditRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        var longContentMock: Meal {
            var randomStrings: [String] = []

            for _ in 1...25 {
                let uuid = UUID()
                let randomString = uuid.uuidString
                randomStrings.append(randomString)
            }

            var meal = Meal.mock()
            meal.strInstructions = randomStrings
            return meal
        }

        NavigationView {
            EditRecipeView(
                meal: Meal.mock()
            )
            .navigationBarHidden(false)
            .accentColor(.white)
        }

        NavigationView {
            EditRecipeView(
                meal: longContentMock
            )
            .navigationBarHidden(false)
            .accentColor(.white)
        }
    }
}
