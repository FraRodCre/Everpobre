//
//  NoteDetailsViewController.swift
//  Everpobre
//
//  Created by Fco_Javier_Rodriguez on 23/10/18.
//  Copyright © 2018 Fco_Javier_Rodriguez. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailsViewController: UIViewController {
    
    // MARK: IBOulets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var lastSeenDateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: Properties
    //let note: NoteOld // Before coredata
    //let note: Note // Before coreData
    enum Kind {
        case new(notebook: Notebook)
        case existing(note: Note)
    }

    let kind: Kind
    let managedContext: NSManagedObjectContext
    
    
    // MARK: Initializers (Markers)
    /* Before coreData
     init(note: Note //NoteOld) {
        self.note = note
        super.init(nibName: "NoteDetailsViewController", bundle: nil)
    }*/
    
    init (kind: Kind, managedContext: NSManagedObjectContext) {
        self.kind = kind
        self.managedContext = managedContext
        super.init(nibName: "NoteDetailsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(with: kind)
    }
    
    // Change information of a note
    private func configure(with kind: Kind) {
        switch kind {
        case .new:
            
            let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
            self.navigationItem.rightBarButtonItem = saveButtonItem
            
            let cancelButtomItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
            navigationItem.leftBarButtonItem = cancelButtomItem
            configureValues()
        case .existing:
            configureValues()
        }
        
    }
    
    @objc private func saveNote() {
        
    }
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    private func configureValues() {
        title = kind.title
        
        titleTextField.text = kind.note?.text
        /*tagsLabel.text = note.tags?.joined(separator: ",")
         creationDateLabel.text = note.creationDate.dateToString()
         lastSeenDateLabel.text = note.lastSeenDate?.dateToString() ?? ""*/
        creationDateLabel.text = (kind.note?.creationDate as Date?)?.dateToString() ?? ""
        lastSeenDateLabel.text = (kind.note?.lastSeenDate as Date?)?.dateToString() ?? ""
        descriptionTextView.text = kind.note?.text ?? "Introducir texto..."
    }
}

private extension NoteDetailsViewController.Kind {
    var note: Note?  {
        guard case let .existing(note) = self else { return nil }
        return note
    }
    
    var title: String {
        switch self {
        case .existing:
            return "Detalle"
        case .new:
            return "Nota nueva"
        }
    }
}
