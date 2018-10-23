//
//  NotebookListCell.swift
//  Everpobre
//
//  Created by Fco_Javier_Rodriguez on 22/10/18.
//  Copyright © 2018 Fco_Javier_Rodriguez. All rights reserved.
//

import UIKit

class NotebookListCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var creationDateLabel: UILabel!
    
    override func prepareForReuse() {
        titleLabel.text = nil
        creationDateLabel.text = nil
        super.prepareForReuse()
    }
    
    // Function for congure the cell of the Notebook
    func configure(with notebook: Notebook){
        titleLabel.text = notebook.name
        creationDateLabel.text = "Creado: \(notebook.creationDate.dateToString())"
    }
}


