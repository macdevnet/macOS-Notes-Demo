//
//  EditController.swift
//  NoteDemo
//
//  Created by Scotty on 02/07/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Foundation

class EditController: NoteEditController
{
    weak var viewDelegate: NoteEditControllerViewDelegate?
    weak var coordinatorDelegate: NoteEditControllerCoordinatorDelegate?
    
    private var note: Note?
    {
        didSet {
            viewDelegate?.noteDidChange(editController: self)
        }
    }
    
    private(set) var id: String
    {
        didSet {
            loadNote()
        }
    }
    
    var dataProvider: NoteDataProvider?
    {
        didSet {
            loadNote()
        }
    }
    
    var noteValues: (title: String, content: NSAttributedString) {
        
        if let note = note {
            return (note.title, note.content)
        } else {
            return ("", NSAttributedString(string: ""))
        }
    }
    
    init(id: String)
    {
        self.id = id
    }
    
    private func loadNote()
    {
        dataProvider?.note(id: id) { (note) in
            dispatch_async(dispatch_get_main_queue()) {
                self.note = note
            }
        }
    }
}



/// NoteEditController Protocol Methods
extension EditController
{
    func updateNoteValues(title title: String, content: NSAttributedString)
    {
        let noteData = NoteData(id: id, title: title, content: content)
        dataProvider?.saveNote(noteData) { (error) in
            
            // Make sure we go back to the main thread
            dispatch_async(dispatch_get_main_queue()) {
                guard let error = error  else {
                    self.coordinatorDelegate?.noteEditControllerDone(controller: self)
                    return
                }
                
                self.viewDelegate?.displayErrorMessage(editController: self, message: error.localizedDescription)
            }
        }
    }
    
    
    func cancel()
    {
        coordinatorDelegate?.noteEditControllerDone(controller: self)
    }
    
    
    func canSaveNoteValues(title title: String, content: NSAttributedString) -> Bool
    {
        // Validate the passed content and decide if it can be saved. 
        // For now just check both values are not whitespace
        let trimmedTitle = title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let trimmedContent = content.string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return trimmedTitle != "" && trimmedContent != ""
    }
}
