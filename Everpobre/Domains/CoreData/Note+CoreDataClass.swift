//
//  Note+CoreDataClass.swift
//  Everpobre
//
//  Created by Fco_Javier_Rodriguez on 24/10/18.
//  Copyright © 2018 Fco_Javier_Rodriguez. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {

}

extension Note {
    func csv() -> String {
        // Params to export
        let exportedTitle = title ?? "Sin título"
        let exportedText = text ?? ""
        let exportedCreationDate = (creationDate as Date?)?.dateToString() ?? "No disponible"
        
        return "\(exportedCreationDate),\(exportedTitle),\(exportedText)"
        
    }
}
