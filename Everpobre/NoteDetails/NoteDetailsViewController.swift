//
//  NoteDetailsViewController.swift
//  Everpobre
//
//  Created by Fco_Javier_Rodriguez on 23/10/18.
//  Copyright © 2018 Fco_Javier_Rodriguez. All rights reserved.
//

import UIKit
import CoreData

protocol NoteDetailsViewControllerDelegate: class {
    func didChangeNote()
}

class NoteDetailsViewController: UIViewController {
    
    // MARK: IBOulets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tagsLabel: UITextField!
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
    var tagID: Int16?
    
    weak var delegate: NoteDetailsViewControllerDelegate?
    //weak var delegate: NoteDetailsViewControllerProtocol?
    
    
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
        
        // Create Picker for tags
        let pickerTag = UIPickerView()
        tagsLabel.inputView = pickerTag
        pickerTag.dataSource = self
        pickerTag.delegate = self
        
        configure()
    }
    
    // Change information of a note
    private func configure() {
        let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
        
        switch kind {
        case .new:
            self.navigationItem.rightBarButtonItem = saveButtonItem
            
            let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSave))
            self.navigationItem.leftBarButtonItem = cancelButtonItem
            
        case .existing:
            let deleteButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
            self.navigationItem.rightBarButtonItems = [saveButtonItem, deleteButtonItem]
        }
            configureValues()
    }
    
    @objc private func saveNote() {
        
        func addProperties(to note: Note) -> Note {
            note.title = titleTextField.text
            note.text = descriptionTextView.text
            
            let imageData: NSData?
            if let image = imageView.image,
                let data = image.pngData() {
                    imageData = NSData(data: data)
            } else { imageData = nil }
            note.image = imageData
            
            if let tag = tagID {
                note.tags = tag
            }
            
            return note
        }
        
        switch kind {
        case .existing(let note):
            
            /*note.title = titleTextField.text
            note.text = descriptionTextView.text
             note.lastSeenDate = NSDate()*/
            let modifiedNote = addProperties(to: note)
            modifiedNote.lastSeenDate = NSDate()
            
        case .new(let notebook):
            let note = Note(context: managedContext)
            /*note.title = titleTextField.text
            note.text = descriptionTextView.text
            note.creationDate = NSDate()
             note.notebook = notebook */
            let modifiedNote = addProperties(to: note)
            modifiedNote.notebook = notebook
            
            if let notes = notebook.notes?.mutableCopy() as? NSMutableOrderedSet {
                notes.add(note)
                notebook.notes = notes
            }
        }
        // save context
        do {
            try managedContext.save()
            delegate?.didChangeNote()
            //delegate?.didSaveNote()
        }catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        
        switch kind {
        case .existing:
            navigationController?.popViewController(animated: true)
        case .new:
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func cancelSave() {
        switch kind {
        case .existing(let note):
            let modifiedNote = note
            modifiedNote.lastSeenDate = NSDate()
        default:
            break
        }
        
        do {
            try managedContext.save()
            delegate?.didChangeNote()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func deleteNote() {
        switch kind {
        case .existing(let note):
            managedContext.delete(note)
        default:
            break
        }
        
        do {
            try managedContext.save()
            delegate?.didChangeNote()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        
        switch kind {
        case .existing:
            navigationController?.popViewController(animated: true)
        case .new:
            dismiss(animated: true, completion: nil)
        }
        //dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickImage(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    private func showPhotoMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: {_ in self.takePhotoWithCamara()})
        let chooseFromLibrary = UIAlertAction(title: "Choose from Library", style: .default, handler: {_ in self.choosePhotoFromLibrary()})
        
        alertController.addAction(cancelAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(chooseFromLibrary)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func takePhotoWithCamara() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func configureValues() {
        title = kind.title
        
        titleTextField.text = kind.note?.title
        /*tagsLabel.text = note.tags?.joined(separator: ",")
         creationDateLabel.text = note.creationDate.dateToString()
         lastSeenDateLabel.text = note.lastSeenDate?.dateToString() ?? ""*/
        creationDateLabel.text = (kind.note?.creationDate as Date?)?.dateToString() ?? "No disponible"
        lastSeenDateLabel.text = (kind.note?.lastSeenDate as Date?)?.dateToString() ?? "No disponible"
        descriptionTextView.text = kind.note?.text ?? "Introducir texto..."
        
        guard let data = kind.note?.image as Data? else {
            imageView.image = #imageLiteral(resourceName: "120x180")
            return
        }
        
        imageView.image = UIImage(data: data)
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

extension NoteDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
            return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
        }
        
        func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
            return input.rawValue
        }
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        let rawImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
        
        let imageSize = CGSize(width: self.imageView.bounds.width * UIScreen.main.scale, height: self.imageView.bounds.height * UIScreen.main.scale)
        
        DispatchQueue.global(qos: .default).async {
            let image = rawImage?.resizedImageWithContentMode(.scaleAspectFill, bounds: imageSize, interpolationQuality: .high)
            
            DispatchQueue.main.async {
                if let image = image {
                    self.imageView.contentMode = .scaleAspectFill
                    self.imageView.clipsToBounds = true
                    self.imageView.image = image
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension NoteDetailsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Tag.allCases.count
    }
}

extension NoteDetailsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Tag.allCases[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tagsLabel.text = Tag.allCases[row].description
        tagID = Tag.allCases[row].rawValue
    }
}
