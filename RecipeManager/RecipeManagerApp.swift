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

    init() {
        UINavigationBar.appearance().backgroundColor = UIColor(ColorScheme.primary)
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor(ColorScheme.variant),
            .font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]

        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor(ColorScheme.variant)], for: .normal)
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor:
                UIColor(ColorScheme.onPrimary)
        ]
        UINavigationBar.appearance().tintColor = UIColor(ColorScheme.primary)

        UINavigationBar.appearance().barTintColor = UIColor(ColorScheme.variant)
        UINavigationBar.appearance().tintColor = UIColor(ColorScheme.variant)

        UITabBar.appearance().backgroundColor = UIColor(ColorScheme.primary)
        UITabBar.appearance().unselectedItemTintColor = .gray
        UITabBar.appearance().tintColor = .gray
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(
                    \.managedObjectContext,
                    persistenceController.container.viewContext
                )
        }
    }
}
