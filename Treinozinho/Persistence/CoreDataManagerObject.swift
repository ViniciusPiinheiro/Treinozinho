//
//  CoreDataManagerObject.swift
//  Treinozinho
//
//  Created by Vinícius Pinheiro on 21/07/21.
//

import UIKit
import CoreData

enum FilterType: String {
    case movieTitle
    
    var value: String {
        switch self {
        case .movieTitle:
            return "movieTitle == %@"
        
        }
    }
}

enum CoreDataEntity: String {
    case Film
    
    var name: String {
        switch self {
        case .Film:
            return "Film"
        }
    }
}

enum MovieAttributes: String {
    case movieTitle
    
    var Key: String {
        switch self {
        case .movieTitle:
            return "movieTitle"
        }
    }
}

class CoreDataManagerObject {
    
    internal enum StatusInCoreData {
        case recoverError
        case recoverSucess
        case notPersistenceData
        case fetchError
        
        var description: String {
            switch self {
                case .recoverError:
                    return "Error in data recover!"
                case .notPersistenceData:
                    return "You don't have data in Persistence"
                case .fetchError:
                    return "Error in fetch operation!"
                case .recoverSucess:
                    return "Sucess in data recover! It's %d objects in persistence!"
            
            }
        }
    }
    
    internal let appDelegate: AppDelegate?
    internal var context: NSManagedObjectContext?
    
    public var movies = [Movie]()
    private var moviesData = [NSManagedObject]()
    
    private static var privateShared: CoreDataManagerObject?
    
    class var shared: CoreDataManagerObject {
        guard let uwShared = privateShared else {
            privateShared = CoreDataManagerObject()
            return privateShared!
        }
        return uwShared
    }
    
    class func destroy() {
        privateShared = nil
        privateShared?.context?.reset()
    }
    
    init() {
        movies = []
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
    }
    
    private func converteDataInObject() {
        for movie in moviesData {
            let movie = Movie(movie: movie)
            movies.append(movie)
        }
    }
    
    public func saveObjectInCoreData(object: Any, entity: CoreDataEntity = .Film) {
        guard let context = context else { return }
        
        let coreDataObject = NSEntityDescription.insertNewObject(forEntityName: entity.name, into: context)
        
        if let movie = object as? Movie {
            coreDataObject.setValue(movie.movieTitle, forKey: MovieAttributes.movieTitle.Key)
        } else { return }
        appDelegate?.saveContext(operationName: .save)
    }
    
    public func recoverData(entityName: CoreDataEntity) {
        guard let context =  context else { return }
        let requisition = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.name)
        if entityName == .Film {
            filmFetch(context: context, requisition: requisition)
        }
    }
    
    private func filmFetch(context: NSManagedObjectContext, requisition: NSFetchRequest<NSFetchRequestResult>) {
        do {
            let movieDt = try context.fetch(requisition)
            self.moviesData = []
            if !movieDt.isEmpty {
                for mv in movieDt as! [NSManagedObject] {
                    self.moviesData.append(mv)
                }
            }
            if !self.moviesData.isEmpty {
                let sucessMessage =  String(format: StatusInCoreData.recoverSucess.description, moviesData.count)
                statusDescription(status: sucessMessage)
                converteDataInObject()
            } else {
                statusDescription(status: StatusInCoreData.notPersistenceData.description)
            }
        } catch {
            let error = error as NSError
            statusDescription(status: StatusInCoreData.recoverError.description, error: error)
        }
    }
    
    private func deleteByObject(element: NSManagedObject) {
        guard let context = context else { return }
        context.delete(element)
        appDelegate?.saveContext(operationName: .delete)
    }
    
    private func deleteByDataFilter(with filterType: FilterType, filterData: String, entityName: CoreDataEntity) {
        
        guard let context = context else {
            return
        }
        guard let element = filterInCoreData(entityName: entityName, with: filterType, the: filterData, context: context) else { return }
        context.delete(element)
        appDelegate?.saveContext(operationName: .delete)
        
    }
    
    private func filterInCoreData(entityName: CoreDataEntity, with filterType: FilterType, the attributeKey: String, context: NSManagedObjectContext) -> NSManagedObject? {
        
        let requisition = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.name)
        let resultData = NSPredicate(format: filterType.value, attributeKey)
        requisition.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [resultData])
        
        do {
            let data = try context.fetch(requisition)
            if data.count != 0 {
                let result = data as! [NSManagedObject]
                return result.first
            }
        } catch {
            let error = error as NSError
            statusDescription(status: StatusInCoreData.fetchError.description, error: error)
        }
        return nil
    }
}

extension CoreDataManagerObject {
    public func statusDescription(status: String, error: NSError? = nil) {
        if let error = error {
            print(String(format: .statusError, status.description, error, error.localizedDescription, error.userInfo))
        } else {
            print(String(format: .format, status.description))
        }
    }
}
