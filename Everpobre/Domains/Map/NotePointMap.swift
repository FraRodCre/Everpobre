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
        //let lat: Double = 37.3828300
        //let long: Double = -5.9731700
        super.init()
        
        self.coordinate = CLLocationCoordinate2D(latitude: note.latitude, longitude: note.longitude)
        self.title = note.title
    }
}
