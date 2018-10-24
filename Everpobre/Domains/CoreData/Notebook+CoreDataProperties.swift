//
//  Notebook+CoreDataProperties.swift
//  Everpobre
//
//  Created by Fco_Javier_Rodriguez on 24/10/18.
//  Copyright © 2018 Fco_Javier_Rodriguez. All rights reserved.
//
//

import Foundation
import CoreData


extension Notebook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notebook> {
        return NSFetchRequest<Notebook>(entityName: "Notebook")
    }

    @NSManaged public var name: String?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var notes: NSSet?

}

// MARK: Generated accessors for notes
extension Notebook {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Note)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}
