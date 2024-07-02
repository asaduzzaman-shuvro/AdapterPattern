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
        let context = NSManagedObjectContext.mr_default()
        let users = User.mr_findAll(in: context) as! [User]
        return users
    }
    
    func createUser(
        name: String,
        email: String
    ) {
        let context = NSManagedObjectContext.mr_default()
        let user = User.mr_findFirstOrCreate(
            byAttribute: User.Fields.name,
            withValue: name
        )
        let products = self.createProduct(for: user, in: context)
        user.name = name
        user.email = email
        user.userId = email
        user.isActive = true
        user.addToProducts(NSSet(array: products))
        context.mr_saveToPersistentStoreAndWait()
    }
    
    func updateUser(
        with name: String,
        isActive: Bool
    ) {
        let context = NSManagedObjectContext.mr_default()
        let user = User.mr_findFirst(
            byAttribute: User.Fields.name,
            withValue: name,
            in: context
        )
        user?.name = name
        user?.isActive = isActive
        context.mr_saveToPersistentStoreAndWait()
    }
    
    private func createProduct(
        for user: User,
        in context: NSManagedObjectContext
    ) -> [Product] {
        var products = [Product]()
        
        for i in 0..<10 {
            let product = Product.mr_findFirstOrCreate(
                byAttribute: Product.Fields.id,
                withValue: "Product \(i)",
                in: context
            )
            product.id = "\(i)"
            product.name = "Product \(i)"
            product.createdAt = Date()
            product.updatedAt = nil
//            product.user = user
            products.append(
                product
            )
        }
        return products
    }
}
