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

enum Tag: Int16, CaseIterable, CustomStringConvertible {
    case Info = 1
    case Personal = 2
    case Otros = 3
    case Todo = 4
    
    var description: String {
        switch self {
        case .Info: return "Info"
        case .Personal: return "Personal"
        case .Otros: return "Otros"
        case .Todo: return "Todo"
        }
    }
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
