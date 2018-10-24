//
//  NoteDetailsViewController.swift
//  Everpobre
//
//  Created by Fco_Javier_Rodriguez on 23/10/18.
//  Copyright © 2018 Fco_Javier_Rodriguez. All rights reserved.
//

import UIKit

class NoteDetailsViewController: UIViewController {
    
    // MARK: IBOulets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var lastSeenDateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: Properties
    let note: NoteOld
    
    // MARK: Initializers (Markers)
    init(note: NoteOld) {
        self.note = note
        super.init(nibName: "NoteDetailsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // Change information of a note
    private func configure() {
        title = "Detalle"
        titleLabel.text = note.text
        tagsLabel.text = note.tags?.joined(separator: ",")
        creationDateLabel.text = note.creationDate.dateToString()
        lastSeenDateLabel.text = note.lastSeenDate?.dateToString() ?? ""
        descriptionTextView.text = note.text ?? "Introducir texto..."
    }
}
