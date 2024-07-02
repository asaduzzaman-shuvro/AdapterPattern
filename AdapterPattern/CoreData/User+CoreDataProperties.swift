//
//  User+CoreDataProperties.swift
//  AdapterPattern
//
//  Created by Asaduzzaman Shuvro on 2/7/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var userId: String?
    @NSManaged public var email: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var products: NSSet?
}

// MARK: Generated accessors for products
extension User {
    
    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Product)
    
    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Product)
    
    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)
    
    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)
    
}

extension User: Identifiable {}

extension User {
    struct Fields {
        static let name = "name"
        static let userId = "userId"
        static let email = "email"
        static let isActive = "isActive"
        static let product = "product"
    }
}
