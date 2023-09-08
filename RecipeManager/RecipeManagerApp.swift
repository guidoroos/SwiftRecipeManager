//
//  RecipeManagerApp.swift
//  RecipeManager
//
//  Created by Guido Roos on 08/09/2023.
//

import SwiftUI

@main
struct RecipeManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
