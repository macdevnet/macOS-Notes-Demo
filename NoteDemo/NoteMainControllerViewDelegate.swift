//
//  NoteMainControllerDelegate.swift
//  NoteDemo
//
//  Created by Scotty on 30/06/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Foundation

protocol NoteMainControllerViewDelegate: class
{
    func notesDidChange(controller controller: NoteMainController)
}
