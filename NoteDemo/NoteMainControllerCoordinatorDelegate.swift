//
//  NoteMainControllerCoordinatorDelegate.swift
//  NoteDemo
//
//  Created by Scotty on 02/07/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Foundation


protocol NoteMainControllerCoordinatorDelegate: class
{
    func newNote()
    func editNote(id id: String)
    func previewNote(id id: String, position: NSPoint, timeBasedDisplay: Bool)
}
