//
//  MainController.swift
//  NoteDemo
//
//  Created by Scotty on 30/06/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Foundation

protocol NoteMainController: class
{
    var viewDelegate: NoteMainControllerViewDelegate? {get set}
    var numberOfNotes: Int { get }
    func note(index index: Int) -> Note?
    func editNote(index index: Int)
    func previewNote(index index: Int, position: NSPoint)
    func newNote()
}
