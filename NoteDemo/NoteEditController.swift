//
//  NoteEditController.swift
//  NoteDemo
//
//  Created by Scotty on 02/07/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Foundation

protocol NoteEditController: class
{
    var viewDelegate: NoteEditControllerViewDelegate? {get set}
    var noteValues: (title: String, content: NSAttributedString) { get }
    
    func updateNoteValues(title title: String, content: NSAttributedString)
    func canSaveNoteValues(title title: String, content: NSAttributedString) -> Bool
    func cancel()
}
