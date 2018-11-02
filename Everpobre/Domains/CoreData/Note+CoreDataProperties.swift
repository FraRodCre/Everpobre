//
//  Note+CoreDataProperties.swift
//  Everpobre
//
//  Created by Fco_Javier_Rodriguez on 03/11/2018.
//  Copyright © 2018 Fco_Javier_Rodriguez. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var lastSeenDate: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var image: NSData?
    @NSManaged public var notebook: Notebook?

}
