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
    let coreDataWrapper: CoreDataWrapper = ConcreteCoreDataWrapper()
    
    private init() {}
    
    func setupCoreDataStack() {
//        MagicalRecord.setupCoreDataStack(withAutoMigratingSqliteStoreNamed: "AdapterPattern.sqlite")
    }
    
    func getUsers() -> [User] {
        let users: [User] = coreDataWrapper.findAll()
        return users
    }
    
    func createUser(
        name: String,
        email: String
    ) {
        coreDataWrapper.asynchronousContext { [weak self] context in
            guard let self else { return }
            let user: User = context.createEntity()
            let products: [Product] = createProduct(for: user, in: context)
            user.products = NSSet(object: products)
        }

    }
    
    func updateUser(
        with name: String,
        email: String,
        userId: String,
        isActive: Bool
    ) {
        coreDataWrapper.asynchronousContext { context in
            let user: User = context.findFirstOrCreate(
                by:User.Fields.userId,
                withValue: userId
            )
            user.name = name
            user.email = email
            user.isActive = isActive
        }
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
        in context: CoreDataAsynchronousContext
    ) -> [Product] {
        var products = [Product]()
        
        let randomNumber = Int.random(in: 0..<10)

        for i in 0..<randomNumber {
            let product: Product = context.createEntity()
            product.id = "\(i)"
            product.name = "Product \(i)"
            product.createdAt = Date()
            product.updatedAt = nil
            product.user = user
            products.append(
                product
            )
        }
        return []
    }
}
