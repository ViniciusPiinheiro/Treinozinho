//
//  CoreDataFunctions.swift
//  Treinozinho
//
//  Created by Vinícius Pinheiro on 21/07/21.
//

import UIKit
import CoreData

enum coreDataOperations: String {
    
    case delete
    case save
    case update
    case unknown
    
    var name: String {
        switch self {
            case .delete:
                return "DELETE"            
            case .save:
                return "SAVE"
            case .update:
                return "UPDATE"
            case .unknown:
                return "UNKNOWN"
        }
    }
}

extension AppDelegate {
    // MARK: - Core Data Saving support

    func saveContext (operationName: coreDataOperations = .unknown) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                print("sucess in \(operationName.name)")
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Error in \(operationName.name) operation! \n Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
