//
//  Product+CoreDataProperties.swift
//  AdapterPattern
//
//  Created by Asaduzzaman Shuvro on 2/7/24.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var user: User?
}

extension Product : Identifiable {

}

extension Product {
    struct Fields {
        static let id = "id"
        static let name = "name"
        static let type = "type"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
        static let user = "user"
    }
}
