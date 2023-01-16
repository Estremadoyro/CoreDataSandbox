//
//  Person+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Leonardo  on 15/01/23.
//
//

import Foundation
import CoreData

public extension Person {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged var name: String?
    @NSManaged var age: Int64
    @NSManaged var gender: String?
    @NSManaged var family: Family?
}

extension Person: Identifiable {}
