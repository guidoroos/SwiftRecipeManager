//
//  PersistanceController.swift
//  RecipeManager
//
//  Created by Guido Roos on 20/09/2023.
//

import CoreData
import Foundation

final class PersistenceController {
    static let shared = PersistenceController()

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RecipeManager")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    private init() {}

    public func saveContext(backgroundContext: NSManagedObjectContext? = nil) throws {
        let context = backgroundContext ?? container.viewContext
        guard context.hasChanges else { return }
        try context.save()
    }
}
