//
//  Family+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Leonardo  on 15/01/23.
//
//

import Foundation
import CoreData

public extension Family {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Family> {
        return NSFetchRequest<Family>(entityName: "Family")
    }

    @NSManaged var name: String?
    @NSManaged var people: NSSet?
}

// MARK: Generated accessors for people
public extension Family {
    @objc(addPeopleObject:)
    @NSManaged func addToPeople(_ value: Person)

    @objc(removePeopleObject:)
    @NSManaged func removeFromPeople(_ value: Person)

    @objc(addPeople:)
    @NSManaged func addToPeople(_ values: NSSet)

    @objc(removePeople:)
    @NSManaged func removeFromPeople(_ values: NSSet)
}

extension Family: Identifiable {}
