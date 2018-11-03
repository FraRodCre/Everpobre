//
//  NoteListCollectionViewController.swift
//  Everpobre
//
//  Created by Fco_Javier_Rodriguez on 02/11/2018.
//  Copyright © 2018 Fco_Javier_Rodriguez. All rights reserved.
//

import UIKit
import CoreData

class NoteListCollectionViewController: UIViewController {

    // MARK: IBOulets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Properties
    let notebook: Notebook
    //let managedContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack!
    
    var notes: [Note] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: Initializers (Markers)
    init(notebook: Notebook, coreDataStack: CoreDataStack) {
        self.notebook = notebook
        self.notes = (notebook.notes?.array as? [Note]) ?? []
        self.coreDataStack = coreDataStack
        super.init(nibName: "NoteListCollectionViewController", bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title =  "Notas"
        self.view.backgroundColor = .white
        
        let nib = UINib(nibName: "NotesListCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "NotesListCollectionViewCell")
        
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        let exportButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(exportCSV))
        self.navigationItem.rightBarButtonItems = [addButtonItem, exportButtonItem]
    }
    
    @objc private func exportCSV(){
        
        coreDataStack.storeContainer.performBackgroundTask{
            [unowned self] context in
            
            var results: [Note] = []
            
            do {
                results = try self.coreDataStack.managedContext.fetch(self.notesFecthRequest(from: self.notebook))
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
            
            let exportPath = NSTemporaryDirectory() + "export.csv"
            let exportURL = URL(fileURLWithPath: exportPath)
            FileManager.default.createFile(atPath: exportPath, contents: Data(), attributes: nil)
            
            let fileHandle: FileHandle?
            do {
                fileHandle = try FileHandle(forWritingTo: exportURL)
            } catch let error as NSError{
                print(error.localizedDescription)
                fileHandle = nil
            }
            
            if let fileHandle = fileHandle {
                
                for note in results {
                    fileHandle.seekToEndOfFile()
                    guard let csvData = note.csv().data(using: .utf8, allowLossyConversion: false) else { return }
                    fileHandle.write(csvData)
                }
                
                fileHandle.closeFile()
                DispatchQueue.main.async {
                    [weak self] in self?.showExportFinishedAlert(exportPath)
                }
                
            } else {
                print("No se pueden exportar los datos")
            }
            
        }
    }
    
    private func showExportFinishedAlert(_ exportPath: String) {
        let message = "El archivo CSV se ha exportado en \(exportPath)"
        let alertController = UIAlertController(title: "Exportación terminada", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dimiss", style: .default)
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true)
    }
    
    private func notesFecthRequest(from notebook: Notebook) -> NSFetchRequest<Note> {
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        //fetchRequest.fetchBatchSize = 50
        fetchRequest.predicate = NSPredicate(format: "notebook == %@", notebook)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        return fetchRequest
    }
    
    @objc private func addNote(){
        let newNoteVC = NoteDetailsViewController(kind: .new(notebook: notebook), managedContext: coreDataStack.managedContext)
        newNoteVC.delegate = self
        
        let navVC = UINavigationController(rootViewController: newNoteVC)
        self.present(navVC, animated: true, completion: nil)
    }
}

extension NoteListCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotesListCollectionViewCell", for: indexPath) as! NotesListCollectionViewCell
        cell.configure(with: notes[indexPath.row])
        
        return cell
    }
}

extension NoteListCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = NoteDetailsViewController(kind: .existing(note: notes[indexPath.row]), managedContext: coreDataStack.managedContext)
        detailVC.delegate = self
        self.show(detailVC, sender: nil)
    }
}

extension NoteListCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
}

extension NoteListCollectionViewController: NoteDetailsViewControllerProtocol {
    func didSaveNote() {
        self.notes = (notebook.notes?.array as? [Note]) ?? []
    }
}
