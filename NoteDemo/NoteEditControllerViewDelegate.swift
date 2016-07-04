//
//  NoteEditControllerViewDelegate.swift
//  NoteDemo
//
//  Created by Scotty on 02/07/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Foundation


protocol NoteEditControllerViewDelegate: class
{
    func noteDidChange(editController editController: NoteEditController)
    func displayErrorMessage(editController editController: NoteEditController, message: String)
}
