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
    
    var modelNotebook: [NotebookOld] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        // Load data in the model (Notebooks)
        modelNotebook = NotebookOld.dummyNotebookModel
        
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
        return modelNotebook.count
    }
    
    // Cell to use
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_NOTEBOOK_LIST_VIEW_CONTROLLER, for: indexPath) as! NotebookListCell
        cell.configure(with: modelNotebook[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate implementation

extension NotebookListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notebook = modelNotebook[indexPath.row]
        let notesListVC = NotesListViewController(notebook: notebook)
        show(notesListVC, sender: nil)
    }
}
