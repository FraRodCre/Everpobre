//
//  NotesListViewController.swift
//  Everpobre
//
//  Created by Fco_Javier_Rodriguez on 22/10/18.
//  Copyright © 2018 Fco_Javier_Rodriguez. All rights reserved.
//

import UIKit

class NotesListViewController: UIViewController {
    // Create a tableView by code
    lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    let notebook: Notebook //NotebookOld
    
    /* Notes before Coredata
     var notes: [NoteOld] = [] {
        // When reset reload data
        didSet {
            tableView.reloadData()
        }
    }*/
    
    var notes: [Note] {
        guard let notes = notebook.notes?.array else { return [] }
        
        return notes as! [Note]
    }
    
    // MARK: Initializers (Markers)
    init(notebook: Notebook /*NotebookOld*/) {
        self.notebook = notebook
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //title = "Notas de: \(notebook.name)" // Before coredata
        title = "Notas"
        
        setupTableView()
        //notes = notebook.notes // Before coredata
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
        let detailVC = NoteDetailsViewController(note: notes[indexPath.row])
        show(detailVC, sender: nil)
    }
}
