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
   /* let locationManager = CLLocationManager()
    var notes: [Note]
    var locationsNotes:[NotePointMap] = []*/
    
    var fetchedResultsController: NSFetchedResultsController<Note>
    
    // MARK: - Initialization (Markers)
    init(notebook: Notebook, coreDataStack: CoreDataStack, fetchedResultsController: NSFetchedResultsController<Note>) {
        self.notebook = notebook
        self.coreDataStack = coreDataStack
        //self.notes = (notebook.notes?.array as? [Note]) ?? []
        self.fetchedResultsController = fetchedResultsController
        
        super.init(nibName: nil, bundle: nil)
        
        title = "Mapa de Notas"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*deinit {
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        //configureLocation()
        confLocations()
    }
    
    func confLocations() {
        var pointsNotes: [MKPointAnnotation] = []
        if let notes = fetchedResultsController.fetchedObjects {
            for note in notes {
                let point = NotePointMap(with: note)
                pointsNotes.append(point)
                /*if note.longitude != nil, note.latitude != nil {
                    let point = NotePointMap(with: note)
                    pointsNotes.append(point)
                }*/
            }
        }
        
        if let mapView = mapView, pointsNotes.count > 0 {
            mapView.showAnnotations(pointsNotes, animated: true)
        }
    }
    
    /*func configureLocation(){
        let center = CLLocationCoordinate2D(latitude: 37.3828300, longitude: -5.9731700)
        let regionRadius: CLLocationDistance = 1000000
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionRadius, longitudinalMeters: 1000)
        
        mapView.setRegion(region, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
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
    }*/
}

// MARK: - Delegate implementation for get info a point(Note) and edit this point
extension NotesListMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let pointNote = view.annotation as? NotePointMap {
            let note = pointNote.note
            let noteView = NoteDetailsViewController(kind: .existing(note: note), managedContext: coreDataStack.managedContext)
            noteView.delegate = tabBarController as! ListOrMapNotesTBC
            self.navigationController?.pushViewController(noteView, animated: true)
        }
    }
    /*func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
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
    }*/
}
