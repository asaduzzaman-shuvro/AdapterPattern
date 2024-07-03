//
//  CoreDataWrapper.swift
//  AdapterPattern
//
//  Created by Asaduzzaman Shuvro on 3/7/24.
//

import Foundation
import CoreData

protocol CoreDataWrapper {
    func create<T: NSManagedObject>() -> T
    func findAll<T: NSManagedObject>() -> [T]
    func findFirst<T: NSManagedObject>(by attribute: String, with value: String ) -> T?
    func findFirstOrCreate<T: NSManagedObject>(by attribute: String, with value: String ) -> T
    
    typealias AsynchronousContextCompletion = ((CoreDataAsynchronousContext)) -> Void
    func asynchronousContext(completion: @escaping AsynchronousContextCompletion)
}


