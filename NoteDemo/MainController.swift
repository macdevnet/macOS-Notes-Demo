//
//  MainController.swift
//  NoteDemo
//
//  Created by Scotty on 30/06/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Cocoa

class MainController
{
    weak var viewDelegate: NoteMainControllerViewDelegate?
    weak var coordinatorDelegate: NoteMainControllerCoordinatorDelegate?
    
    var dataProvider: NoteDataProvider?
    {
        willSet {
            dataProvider?.delegate = nil
        }
        didSet {
            dataProvider?.delegate = self
            loadNotes()
        }
    }
    
    var notes: [Note] = [Note]() {
        didSet {
            viewDelegate?.notesDidChange(controller: self)
        }
    }
    
    var numberOfNotes: Int {
        return notes.count
    }
    
}



/// NoteMainController Methods
extension MainController: NoteMainController
{
    func note(index index: Int) -> Note?
    {
        guard index >= 0 && index < notes.count else {return nil}
        return notes[index]
    }
    
    
    func editNote(index index: Int)
    {
        if let note = note(index: index) {
            coordinatorDelegate?.editNote(id: note.id)
        }
    }
    

    func previewNote(index index: Int, position: NSPoint)
    {
       if let note = note(index: index) {
            coordinatorDelegate?.previewNote(id: note.id, position: position, timeBasedDisplay: false)
        }
    }
    
    func newNote()
    {
        coordinatorDelegate?.newNote()
    }
}



/// NoteDataProviderDelegate Methods
extension MainController: NoteDataProviderDelegate
{
    func noteChanged(id id: String) {
        dispatch_async(dispatch_get_main_queue()) {
            self.loadNotes()
        }
    }
    
    func notesLoaded() {
        dispatch_async(dispatch_get_main_queue()) {
            self.loadNotes()
        }
    }
    
    private func loadNotes()
    {
        if let dataProvider = dataProvider {
            dataProvider.notes({ (notes) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.notes = notes
                }
            })
        } else {
            self.notes = [Note]()
        }
    }
}
