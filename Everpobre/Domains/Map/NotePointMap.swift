//
//  NotePointMap.swift
//  Everpobre
//
//  Created by Fco_Javier_Rodriguez on 04/11/2018.
//  Copyright © 2018 Fco_Javier_Rodriguez. All rights reserved.
//

import Foundation
import MapKit

// Point of interest in the map
class NotePointMap: MKPointAnnotation {
    // Have information a note whit implementation
    var note: Note
    
    init(with note: Note) {
        self.note = note
        
        super.init()
        
        self.coordinate = CLLocationCoordinate2D(latitude: note.latitude, longitude: note.longitude)
        self.title = note.title
    }
}
