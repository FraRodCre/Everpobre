//
//  NotesListMapViewController.swift
//  Everpobre
//
//  Created by Fco_Javier_Rodriguez on 04/11/2018.
//  Copyright © 2018 Fco_Javier_Rodriguez. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class NotesListMapViewController: UIViewController {

    // MARK: IBOulet
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    let notebook: Notebook
    let coreDataStack: CoreDataStack
    let locationManager = CLLocationManager()
    var notes: [Note]
    var locationsNotes:[NotePointMap] = []
    
    // MARK: - Initialization (Markers)
    init(notebook: Notebook, coreDataStack: CoreDataStack) {
        self.notebook = notebook
        self.coreDataStack = coreDataStack
        self.notes = (notebook.notes?.array as? [Note]) ?? []
        
        super.init(nibName: nil, bundle: nil)
        
        title = "Mapa de Notas"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        configureLocation()
    }
    
    func configureLocation(){
        let center = CLLocationCoordinate2D(latitude: 37.3828300, longitude: -5.9731700)
        let regionRadius: CLLocationDistance = 100000
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionRadius, longitudinalMeters: 1000)
        
        mapView.setRegion(region, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Nos damos de alta en las notificaciones
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(notesDidChange), name: Notification.Name(rawValue: "didAddNote"), object: nil)
    }
    
    @objc func notesDidChange(notification: Notification) {
        self.notes = (notebook.notes?.array as? [Note]) ?? []
        mapView.annotations.forEach{mapView.removeAnnotation($0)}
        
        loadLocationsNotes()
        mapView.addAnnotations(locationsNotes)
    }
    
    func loadLocationsNotes(){
        notes.forEach{
            note in
                let pointLocationNote = NotePointMap(with: note)
                locationsNotes.append(pointLocationNote)
        }
    }
}

// MARK: - Delegate implementation for get info a point(Note) and edit this point
extension NotesListMapViewController: MKMapViewDelegate {
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        loadLocationsNotes()
        mapView.addAnnotations(locationsNotes)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotacionView = mapView.dequeueReusableAnnotationView(withIdentifier: "locationsNotes") as? MKMarkerAnnotationView
        
        if annotacionView == nil {
            annotacionView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "locationsNotes")
        } else {
            annotacionView?.annotation = annotation
        }
        
        annotacionView?.markerTintColor = .red
        annotacionView?.titleVisibility = .visible
        annotacionView?.subtitleVisibility = .adaptive
        
        return annotacionView
    }
}
