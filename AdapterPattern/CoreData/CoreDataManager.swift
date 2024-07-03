//
//  CoreDataManager.swift
//  AdapterPattern
//
//  Created by Asaduzzaman Shuvro on 2/7/24.
//

import Foundation
import MagicalRecord

final class CoreDataManager {
    
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
            byAttribute: User.Fields.userId,
            withValue: String.generateRandomAlphanumeric()
        )
        let products = self.createProduct(for: user, in: context)
      
        user.name = name
        user.email = email
        user.isActive = true
        user.products = NSSet(array: products)
        context.mr_saveToPersistentStoreAndWait()
        
//        let userId = String.generateRandomAlphanumeric()
//        let cordataWrapper: CoreDataWrapper = ConcreteCoreDataWrapper()
//        cordataWrapper.asynchronousContext { context in
//            let user: User = context.findFirstOrCreate(by: User.Fields.userId, withValue: userId)
//            user.userId = userId
//            user.name = "Asaduzzaman Shuvro"
//            user.email = "asaduzzaman@gmail.com"
//        }
    }
    
    func updateUser(
        with name: String,
        email: String,
        userId: String,
        isActive: Bool
    ) {
        let context = NSManagedObjectContext.mr_default()
        let user = User.mr_findFirst(
            byAttribute: User.Fields.userId,
            withValue: userId
        )
        user?.name = name
        user?.email = email
        user?.isActive = isActive
        context.mr_saveToPersistentStoreAndWait()
    }
    
    func userFetchController(delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<NSFetchRequestResult> {
        let userRequest = User.mr_requestAllSorted(
            by: User.Fields.userId,
            ascending: true,
            with: nil
        )
        let controller = User.mr_fetchController(
            userRequest,
            delegate: delegate,
            useFileCache: false,
            groupedBy: nil,
            in: NSManagedObjectContext.mr_default()
        )
        controller.fetchRequest.includesSubentities = false
        User.mr_performFetch(controller)
        return controller
    }
    
    private func createProduct(
        for user: User,
        in context: NSManagedObjectContext
    ) -> [Product] {
        var products = [Product]()
        
        let randomNumber = Int.random(in: 0..<10)

        for i in 0..<randomNumber {
            let product = Product.mr_findFirstOrCreate(
                byAttribute: Product.Fields.id,
                withValue: "Product \(i)",
                in: context
            )
            product.id = "\(i)"
            product.name = "Product \(i)"
            product.createdAt = Date()
            product.updatedAt = nil
            product.user = user
            products.append(
                product
            )
        }
        return products
    }
}
