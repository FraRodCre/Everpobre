//
//  NotebookListController.swift
//  Everpobre
//
//  Created by Fco_Javier_Rodriguez on 20/10/18.
//  Copyright © 2018 Fco_Javier_Rodriguez. All rights reserved.
//

import UIKit
import CoreData

class NotebookListViewController: UIViewController {
    
    // MARK: IBOulets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    
    // MARK: Properties
    //var managedContext: NSManagedObjectContext! // Beware to have a value before presenting the VC
    
    var coredataStack: CoreDataStack!
    
    /* *** This model is not used because the model now is the model created with coredata ***
     var modelNotebook: [NotebookOld] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    var dataSource: [NSManagedObject] = [] {
        didSet {
            tableView.reloadData()
        }
    }*/
    
    var fetchedResultsController: NSFetchedResultsController<Notebook>!
    
    override func viewDidLoad() {
        // Load data in the model (Notebooks) without coreData
        //modelNotebook = NotebookOld.dummyNotebookModel
        
        // Show by code, the title in action bar
        //navigationController?.navigationBar.prefersLargeTitles = true
        //navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        super.viewDidLoad()
        
        let exportButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(exportNotebooks))
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNotebook))
        navigationItem.rightBarButtonItems = [addButtonItem, exportButtonItem]
        
        configureSearchController()
        /*showAll()
        populateTotalLabel()*/
        reloadView()
    }
    
    // Get values necesary for complete the table (This do of "datasource")
    private func getFecthedResultsController(with predicate: NSPredicate = NSPredicate(value: true)) -> NSFetchedResultsController<Notebook> {
        let fetchRequest: NSFetchRequest<Notebook> = Notebook.fetchRequest()
        fetchRequest.predicate = predicate
        
        let sort = NSSortDescriptor(key: #keyPath(Notebook.creationDate), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchBatchSize = 20
        
        // sectionNameKeyPath-> Param used for order by group
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coredataStack.managedContext, sectionNameKeyPath: #keyPath(Notebook.creationDate), cacheName: nil)
    }
    
    private func setNewFetchedResultsController(_ newfrc: NSFetchedResultsController<Notebook>) {
        
        let olddrc = fetchedResultsController
        if (newfrc != olddrc) {
            fetchedResultsController = newfrc
            newfrc.delegate = self
            
            do {
                try fetchedResultsController.performFetch()
                tableView.reloadData()
            } catch let error as NSError {
                print("Could not fetch \(error)")
            }
            
        }
    }
    
    private func showAll(){
        let frc = getFecthedResultsController()
        setNewFetchedResultsController(frc)
    }
    
    private func populateTotalLabel() {
        totalLabel.text = "\(fetchedResultsController.fetchedObjects?.count ?? 0)"
    }
    
    private func reloadView() {
        showAll()
        
        populateTotalLabel()
    }
    
    private func configureSearchController(){
        // Add button search
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Buscar Notebook"
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }
    
    // MARK: IBAction
    @IBAction func addNotebook(_ sender: UIBarButtonItem) {
        // Code implementation for add a note
        let alert = UIAlertController(title: "Nuevo Notebook", message: "Añade un nuevo Notebok", preferredStyle: .alert)
        
        // variable with action for save a notebook
        let saveAction = UIAlertAction(title: "Guardar", style: .default) {
            [unowned self] action in
            
            guard
                // Input in alert for get name of a Notebook
                let textField = alert.textFields?.first,
                let nameToSave = textField.text
                else { return }
            
            // Instance note
            //let notebook = Notebook(context: self.managedContext)
            let notebook = Notebook(context: self.coredataStack.managedContext)
            notebook.name = nameToSave
            notebook.creationDate = NSDate()
            
            do {
                try self.coredataStack.managedContext.save()
            } catch let error as NSError {
                print("TODO Error handling \(error.debugDescription)")
            }
            
            //self.tableView.reloadData()
            // Reload date table and count Notebook
            self.reloadView()
            
        }
        
        
        let  cancelAction = UIAlertAction(title: "Cancelar", style: .default)
        
        // Alert with button saved and cancel action
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc private func exportNotebooks() {
        var results: [Notebook] = []
        do {
            results = try self.coredataStack.managedContext.fetch(Notebook.fetchRequest())
            
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        
        var csv = ""
        for notebook in results {
            csv = "\(csv)\(notebook.csv())"
        }
        
        let activityView = UIActivityViewController(activityItems: [csv], applicationActivities: nil)
        self.present(activityView, animated: true)
    }
    /*private func reloadView(){
        do {
            dataSource = try managedContext.fetch(Notebook.fetchRequest())
        } catch let error as NSError {
            print(error.localizedDescription)
            dataSource =  []
        }
        
        populateTotalLabel()
        
        tableView.reloadData()
    }*/
    
    /*private func populateTotalLabel(with predicate: NSPredicate = NSPredicate(value: true)){
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Notebook")
        fetchRequest.resultType = .countResultType
        
        let predicate = NSPredicate(value: true)
        fetchRequest.predicate = predicate
        
        do{
            let countResult = try coredataStack.managedContext.fetch(fetchRequest)
            let count = countResult.first!.intValue
            totalLabel.text = "\(count)"
        }catch let error as NSError {
            print("Count not  fetch: \(error)")
        }
    }*/
    
}

// MARK: UITableViewDataSource implementation
extension NotebookListViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let section = fetchedResultsController.sections else { return 1 }
        return section.count
    }
    
    // Number of sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return dataSource.count //modelNotebook.count
        
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0}
        
        return sectionInfo.numberOfObjects
    }
    
    // Cell to use
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_NOTEBOOK_LIST_VIEW_CONTROLLER, for: indexPath) as! NotebookListCell
        //cell.configure(with: modelNotebook[indexPath.row])  // get note withou
        
        //let notebook = dataSource[indexPath.row] as! Notebook
        let notebook = fetchedResultsController.object(at: indexPath)
        cell.configure(with: notebook)
        
        return cell
    }
    // Activate edition of a cell (Edition Notebook - default is true)
    /*func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }*/
    
    // Activate removal of a cell (Removel Notebook)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       /* guard
            let notebookToRemove = dataSource[indexPath.row] as? Notebook,
            editingStyle == .delete
        else { return }*/
        
        guard editingStyle == .delete else {  return }
        let notebookToRemove = fetchedResultsController.object(at: indexPath)
        coredataStack.managedContext.delete(notebookToRemove)
        
        do {
            try coredataStack.managedContext.save()
            //tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        
        //tableView.reloadData()
        self.reloadView()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections?[section]
        return sectionInfo?.name
    }
}

// MARK: UITableViewDelegate implementation

extension NotebookListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*  Before coreData
        let notebook = modelNotebook[indexPath.row]
        let notesListVC = NotesListViewController(notebook: notebook)*/
        
        /*let notebook = dataSource [indexPath.row]
        let notesListVC = NotesListViewController(notebook: notebook)
        show(notesListVC, sender: nil)*/
        
        //let notebook = dataSource[indexPath.row] as! Notebook
        let notebook = fetchedResultsController.object(at: indexPath)
        
        let tabBarListOrMapVC = ListOrMapNotesTBC(notebook: notebook, coreDataStack: coredataStack)
        self.navigationController?.pushViewController(tabBarListOrMapVC, animated: true)
        //tableView.deselectRow(at: indexPath, animated: true)
        
        /*let notesListVC = NotesListViewController(notebook: notebook, managedContext: managedContext)
        let notesListVC = NoteListCollectionViewController(notebook: notebook, coreDataStack: coredataStack)
        show(notesListVC, sender: nil)*/
    }
   
}

extension NotebookListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            // Show filtered results
            showFileteredResults(with: text)
        } else {
            // Show all results
            reloadView()
        }
    }
    
    private func showFileteredResults(with query: String) {
        /*let fetchRequest = NSFetchRequest<Notebook>(entityName: "Notebook")
        fetchRequest.resultType = .managedObjectResultType
        
        let predicate = NSPredicate(format: "name CONTAINS[c] %@", query)
        fetchRequest.predicate = predicate
        
        do {
            dataSource = try managedContext.fetch(Notebook.fetchRequest())
        }catch let error as NSError {
            print("Could not fetch \(error)")
            dataSource = []
        }
        
        populateTotalLabel(with: predicate)*/
        
        let predicate = NSPredicate(format: "name CONTAINS[c] %@", query)
        let frc = getFecthedResultsController(with: predicate)
        setNewFetchedResultsController(frc)
        
        populateTotalLabel()
        
        
    }
    
  /*  private func showAll() {
        
        /*let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: Notebook.fetchRequest()) {
            [weak self] (result) in
            guard let notebooks = result.finalResult else {
                self?.dataSource = []
                return
            }
            self?.dataSource = notebooks
        }
        
        do {
            //dataSource = try managedContext.fetch(Notebook.fetchRequest())
            try managedContext.execute(asyncFetchRequest)
        }catch let error as NSError {
            print("Could not fetch \(error)")
            dataSource = []
        }*/
        
        //fetchedResultsController = getFecthedResultsController()
        let frc = getFecthedResultsController()
        setNewFetchedResultsController(frc)
        //fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        }catch let error as NSError {
            print("Could not fetch \(error)")
        }
        populateTotalLabel()
    }*/
}

extension NotebookListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
