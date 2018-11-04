//
//  Notebook+CoreDataClass.swift
//  Everpobre
//
//  Created by Fco_Javier_Rodriguez on 24/10/18.
//  Copyright © 2018 Fco_Javier_Rodriguez. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Notebook)
public class Notebook: NSManagedObject {

}

extension Notebook {
    func csv() -> String {
        let exportedName = name ?? "Fichero"
        let exportedCreationDate = (creationDate as Date?)?.dateToString() ?? ""
        
        var exportedNotes = ""
        if let notes = notes {
            for note in notes {
                if let note = note as? Note {
                    exportedNotes = "\(exportedNotes)\(note.csv())\n"
                }
            }
        }
        
        return "\(exportedCreationDate),\(exportedName)\n\(exportedNotes)"
    }
}
