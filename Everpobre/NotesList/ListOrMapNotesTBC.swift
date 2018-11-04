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
    let coreDataStack: CoreDataStack
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
    
    // Get values necesary for complete the table (This do of "datasource")
    func getFecthedResultsController(with predicate: NSPredicate) -> NSFetchedResultsController<Note> {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.predicate = predicate
        
        let sort = NSSortDescriptor(key: #keyPath(Note.title), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchBatchSize = 20
        
        // sectionNameKeyPath-> Param used for order by group
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func setNewFetchResultsController(_ newfrc: NSFetchedResultsController<Note>) {
        let oldfrc = fetchedResultsController
        if (newfrc != oldfrc) {
            fetchedResultsController = newfrc
            do {
                try fetchedResultsController.performFetch()
                
                notesListVC?.fetchedResultsController = newfrc
                if let collectionView = notesListVC?.collectionView {
                    collectionView.reloadData()
                }
                notesMapVC?.fetchedResultsController = newfrc
                notesMapVC?.confLocations()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAll()
        
        notesListVC = NoteListCollectionViewController(notebook: notebook, coreDataStack: coreDataStack, fetchedResultsController: fetchedResultsController)
        notesMapVC = NotesListMapViewController(notebook: notebook, coreDataStack: coreDataStack, fetchedResultsController: fetchedResultsController)
        //notesMapVC = NotesListMapViewController(notebook: notebook, coreDataStack: coreDataStack)
        
        viewControllers = [notesListVC!, notesMapVC!]
        
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        let exportButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sendNote))
        self.navigationItem.rightBarButtonItems = [addButtonItem, exportButtonItem]
        
        configureSearchController()
        
    }

    @objc private func addNote(){
        let newNoteVC = NoteDetailsViewController(kind: .new(notebook: notebook), managedContext: coreDataStack.managedContext)
        newNoteVC.delegate = self
        
        let navVC = UINavigationController(rootViewController: newNoteVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
    @objc private func sendNote() {
        var results: [Note] = []
        do {
            results = try self.coreDataStack.managedContext.fetch(getFecthedResultsController(with: NSPredicate(format: "notebook == %@", notebook)).fetchRequest)
            
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        
        var csv = ""
        for note in results {
            csv = "\(note.csv())\n"
        }
        
        let activityView = UIActivityViewController(activityItems: [csv], applicationActivities: nil)
        self.present(activityView, animated: true)
    }
    
    private func configureSearchController(){
        // Add button search
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Buscar Nota"
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func showAll() {
        setNewFetchResultsController(getFecthedResultsController(with: NSPredicate(format: "notebook == %@", notebook)))
    }
}

extension ListOrMapNotesTBC: NoteDetailsViewControllerDelegate {
    func didChangeNote() {
        showAll()
    }
}

extension ListOrMapNotesTBC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            showFilteredResults(with: text)
        } else {
            showAll()
        }
    }
    
    private func showFilteredResults(with filter: String) {
        // Tag lookup (Naive and slow)
        var tag: Int16 = -1
        let possibleTags = filter.split(separator: " ")
        for possibleTag in possibleTags {
            for enumTag in Tag.allCases {
                if (String(possibleTag) == enumTag.description) {
                    tag = enumTag.rawValue
                }
            }
        }
        
        let predicate = NSPredicate(format: "notebook == %@ AND (title CONTAINS[c] %@ OR tag == %i)", notebook, filter, tag)
        
        setNewFetchResultsController(getFecthedResultsController(with: predicate))
    }
}
