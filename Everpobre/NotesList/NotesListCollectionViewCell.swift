//
//  NotesListCollectionViewCell.swift
//  Everpobre
//
//  Created by Fco_Javier_Rodriguez on 02/11/2018.
//  Copyright © 2018 Fco_Javier_Rodriguez. All rights reserved.
//

import UIKit

class NotesListCollectionViewCell: UICollectionViewCell {

    // MARK: IBOulet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var imageNote: UIImageView!
    
    // MARK: Properties
    var item: Note!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with item: Note){
        //backgroundColor = .gray
        titleLabel.text = item.title
        creationDateLabel.text = (item.creationDate as Date?)?.dateToString()
        
        if let imageNoteData = item.image, imageNoteData.length > 0 {
            
            imageNote.image = UIImage(data: imageNoteData as Data)
        }
    }
}
