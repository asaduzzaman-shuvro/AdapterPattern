//
//  CoreDataManager.swift
//  AdapterPattern
//
//  Created by Asaduzzaman Shuvro on 2/7/24.
//

import Foundation
import MagicalRecord

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    func setupCoreDataStack() {
        MagicalRecord.setupCoreDataStack(withAutoMigratingSqliteStoreNamed: "AdapterPattern.sqlite")
    }
    
    func getUsers() -> [User] {
        let users = User.mr_findAll(in: NSManagedObjectContext.mr_default()) as! [User]
        return users
    }
    
    func createUser(name: String, email: String) {
        let context = NSManagedObjectContext.mr_context(withParent: .mr_rootSaving())
        context.performAndWait {
            let user = User.mr_createEntity(in: context)
            user?.name = name
            user?.email = email
            user?.userId = email
            user?.isActive = true
            user?.product = nil
        }
    }
    
    func updateUser(with name: String, isActive: Bool) {
        let context = NSManagedObjectContext.mr_context(withParent: .mr_rootSaving())
        let user = User.mr_findFirst(byAttribute: User.Fields.name, withValue: name, in: context)
        context.performAndWait {
            user?.name = name
            user?.isActive = isActive
        }
    }
    
    func addProductTo(user: String, completion: @escaping (() -> Void)) {
        let context = NSManagedObjectContext.mr_context(withParent: .mr_rootSaving())
        let user = User.mr_findFirst(byAttribute: User.Fields.name, withValue: user, in: context)
        var products = [Product]()
        
        for i in 0..<5 {
            products.append(Product.mr_findFirstOrCreate(byAttribute: Product.Fields.id, withValue: "Product \(i)", in: context))
        }
        user?.product = NSSet(object: products)
        context.performAndWait {
            completion()
        }
    }
}
