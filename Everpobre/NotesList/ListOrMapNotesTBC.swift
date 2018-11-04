//
//  ListOrMapNotesTBC.swift
//  Everpobre
//
//  Created by Fco_Javier_Rodriguez on 04/11/2018.
//  Copyright © 2018 Fco_Javier_Rodriguez. All rights reserved.
//

import UIKit
import CoreData

class ListOrMapNotesTBC: UITabBarController{
    // MARK: Properties
    let notebook: Notebook
    //let managedContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack!
    var fetchedResultsController: NSFetchedResultsController<Note>!
    
    var notesListVC: NoteListCollectionViewController?
    var notesMapVC: NotesListMapViewController?
    
    // MARK: Inicializer (Markers)
    init(notebook: Notebook, coreDataStack: CoreDataStack){
        self.notebook = notebook
        self.coreDataStack = coreDataStack
        super.init(nibName: nil, bundle: nil)
        title = "Notas"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesListVC = NoteListCollectionViewController(notebook: notebook, coreDataStack: coreDataStack)
        notesMapVC = NotesListMapViewController(notebook: notebook, coreDataStack: coreDataStack)
        
        viewControllers = [
            notesListVC!,
            notesMapVC!
        ]
    }
    
    private func showExportFinishedAlert(_ exportPath: String) {
        let message = "El archivo CSV se ha exportado en \(exportPath)"
        let alertController = UIAlertController(title: "Exportación terminada", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dimiss", style: .default)
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true)
    }
    
    private func notesFecthRequest(from notebook: Notebook) -> NSFetchRequest<Note> {
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        //fetchRequest.fetchBatchSize = 50
        fetchRequest.predicate = NSPredicate(format: "notebook == %@", notebook)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        return fetchRequest
    }
}

extension ListOrMapNotesTBC: NoteDetailsViewControllerDelegate {
    func didChangeNote() {
        //self.notes = (notebook.notes?.array as? [Note]) ?? []
        
    }
}


