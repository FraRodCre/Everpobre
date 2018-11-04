//
//  NotesListViewController.swift
//  Everpobre
//
//  Created by Fco_Javier_Rodriguez on 22/10/18.
//  Copyright © 2018 Fco_Javier_Rodriguez. All rights reserved.
//

import UIKit
import CoreData

class NotesListViewController: UIViewController {
    // Create a tableView by code
    /*lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    let notebook: Notebook //NotebookOld
    let managedContext: NSManagedObjectContext
    
    /* Notes before Coredata
     var notes: [NoteOld] = [] {
        // When reset reload data
        didSet {
            tableView.reloadData()
        }
    }
    **** with coreData before save note
    var notes: [Note] {
        guard let notes = notebook.notes?.array else { return [] }
        
        return notes as! [Note]
    }*/
    
    var notes: [Note] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: Initializers (Markers)
   init(notebook: Notebook /*NotebookOld*/, managedContext: NSManagedObjectContext) {
        self.notebook = notebook
        self.notes = (notebook.notes?.array as? [Note]) ?? []
        self.managedContext = managedContext
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        //title = "Notas de: \(notebook.name)" // Before coredata
        title = "Notas"
        
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        navigationItem.rightBarButtonItem = addButtonItem
        
        setupTableView()
        //notes = notebook.notes // Before coredata
    }
    
    @objc private func addNote() {
        let newNoteVC = NoteDetailsViewController(kind: .new(notebook: notebook), managedContext: managedContext)
        // Refresh list of notes later to save
        newNoteVC.delegate = self
        let navVC = UINavigationController(rootViewController: newNoteVC)
        present(navVC, animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        // Indicate note(item) to show
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension NotesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = notes[indexPath.row].title
        
        return cell
    }
}

extension NotesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Get note to show
        //let detailVC = NoteDetailsViewController(note: notes[indexPath.row]) // Before coreData
        
        let detailVC = NoteDetailsViewController(kind: .existing(note: notes[indexPath.row]), managedContext: managedContext)
        detailVC.delegate = self
        show(detailVC, sender: nil)
    }
}

extension NotesListViewController: NoteDetailsViewControllerProtocol {
    func didSaveNote() {
        self.notes = (notebook.notes?.array as? [Note]) ?? []
    }
    
}*/
}
