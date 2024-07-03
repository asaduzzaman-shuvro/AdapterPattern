//
//  CoreDataContexts.swift
//  AdapterPattern
//
//  Created by Asaduzzaman Shuvro on 3/7/24.
//

import Foundation
import CoreStore

protocol CoreDataAsynchronousContext {
    func createEntity<T: NSManagedObject>() -> T
    func findFirst<T: NSManagedObject>(by attribute: String, withValue value: String) -> T?
    func findFirstOrCreate<T: NSManagedObject>(by attribute: String, withValue value: String) -> T
}

extension AsynchronousDataTransaction: CoreDataAsynchronousContext  {
    func createEntity<T>() -> T where T : NSManagedObject {
        create(Into<T>())
    }
    
    func findFirst<T>(by attribute: String, withValue value: String) -> T? where T : NSManagedObject {
        let predicate = NSPredicate(format: "%K = %@", attribute, value)
        let object = try? fetchOne(
            From<T>(),
            Where<T>(predicate)
        )
        return object
    }
    
    func findFirstOrCreate<T>(by attribute: String, withValue value: String) -> T where T : NSManagedObject {
        let object: T? = findFirst(by: attribute, withValue: value)
        if let object {
            return object
        } else {
            return createEntity()
        }
    }
}
