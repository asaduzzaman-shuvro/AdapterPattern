//
//  ConcreteCoreDataWrapper.swift
//  AdapterPattern
//
//  Created by Asaduzzaman Shuvro on 3/7/24.
//

import Foundation
import CoreData
import CoreStore

class ConcreteCoreDataWrapper: CoreDataWrapper {
    let dataStack: DataStack
    
    init() {
        dataStack = DataStack(xcodeModelName: "AdapterPattern")
        do {
            try dataStack.addStorageAndWait(getSqliteDatabaseName())
        } catch {
            print(error)
        }
    }
    
    func create<T>() -> T where T : NSManagedObject {
        let transaction = dataStack.beginUnsafe()
        let createdObject = transaction.create(Into<T>())
        try? transaction.commitAndWait()
        return createdObject
    }
        
    func findAll<T>() -> [T] where T : NSManagedObject {
        let objects = try? dataStack.fetchAll(
            From<T>()
        )
        return objects ?? []
    }
    
    
    func findFirst<T>(by attribute: String, with value: String) -> T? where T : NSManagedObject {
        let predicate = NSPredicate(format: "%K = %@", attribute, value)
        let object = try? dataStack.fetchOne(
            From<T>(),
            Where<T>(predicate)
        )
        return object
    }
    
    func findFirstOrCreate<T>(by attribute: String, with value: String) -> T where T : NSManagedObject {
        let object:T? = findFirst(by: attribute, with: value)
        
        if let object = object {
            return object
        } else {
            return self.create()
        }
    }
    
    func asynchronousContext(completion: @escaping AsynchronousContextCompletion) {
        dataStack.perform { transaction in
            completion(transaction)
        } completion: { result in
            print(result)
        }
    }
}

extension ConcreteCoreDataWrapper {
    private func getSqliteDatabaseName() -> SQLiteStore {
        
        let bundleName = "AdapterPattern"
        let databaseName = "AdapterPattern.sqlite"
        let fileManager = FileManager.default
        
        let url = fileManager.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        )[0]
            .appendingPathComponent("\(bundleName)/\(databaseName)")
        return SQLiteStore(fileURL: url)
    }
}
