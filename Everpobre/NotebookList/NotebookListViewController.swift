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
    
    // MARK: Properties
    var managedContext: NSManagedObjectContext! // Beware to have a value before presenting the VC
    
    /* *** This model is not used because the model now is the model created with coredata ***
     var modelNotebook: [NotebookOld] = []{
        didSet{
            tableView.reloadData()
        }
    }*/
    
    var dataSource: [NSManagedObject] {
        do {
            return try managedContext.fetch(Notebook.fetchRequest())
        } catch let error as NSError {
            print(error.localizedDescription)
            return []
        }
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
            let notebook = Notebook(context: self.managedContext)
            notebook.name = nameToSave
            notebook.creationDate = NSDate()
            
            do {
                try self.managedContext.save()
            } catch let error as NSError {
                print("TODO Error handling \(error.debugDescription)")
            }
            
            self.tableView.reloadData()
        }
        
        let  cancelAction = UIAlertAction(title: "Cancelar", style: .default)
        
        // Alert with button saved and cancel action
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
    override func viewDidLoad() {
        // Load data in the model (Notebooks) without coreData
        //modelNotebook = NotebookOld.dummyNotebookModel
        
        // Show by code, the title in action bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        super.viewDidLoad()
    }
    
}

// MARK: UITableViewDataSource implementation
extension NotebookListViewController: UITableViewDataSource{
    
    // Number of sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count //modelNotebook.count
    }
    
    // Cell to use
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_NOTEBOOK_LIST_VIEW_CONTROLLER, for: indexPath) as! NotebookListCell
        //cell.configure(with: modelNotebook[indexPath.row])  // get note withou
        
        let notebook = dataSource[indexPath.row] as! Notebook
        cell.configure(with: notebook)
        
        return cell
    }
    // Activate edition of a cell (Edition Notebook)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Activate removal of a cell (Removel Notebook)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard
            let notebookToRemove = dataSource[indexPath.row] as? Notebook,
            editingStyle == .delete
        else { return }
        
        managedContext.delete(notebookToRemove)
        
        do {
            try managedContext.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
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
        
        let notebook = dataSource[indexPath.row] as! Notebook
        let notesListVC = NotesListViewController(notebook: notebook, managedContext: managedContext)
        show(notesListVC, sender: nil)
    }
}
