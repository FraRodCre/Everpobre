//
//  Note.swift
//  Everpobre
//
//  Created by Fco_Javier_Rodriguez on 22/10/18.
//  Copyright © 2018 Fco_Javier_Rodriguez. All rights reserved.
//

import Foundation

struct NoteOld {
    // MARK: Properties
    let title: String
    let text: String?
    let tags: [String]?
    let creationDate: Date
    let lastSeenDate: Date?
    
    static let dummyNotesModel: [NoteOld] = [
        NoteOld(title: "Primera nota", text: nil, tags: nil, creationDate: Date(), lastSeenDate: nil),
        NoteOld(title: "Segunda nota", text: "Test", tags: nil, creationDate: Date(), lastSeenDate: nil),
        NoteOld(title: "Tercera nota", text: "Texto de prueba", tags: nil, creationDate: Date(), lastSeenDate: nil),
        NoteOld(title: "Cuarta nota", text: "Algo de contenido", tags: nil, creationDate: Date(), lastSeenDate: nil),
        NoteOld(title: "Quinta nota", text: nil, tags: nil, creationDate: Date(), lastSeenDate: nil)
    ]
}
