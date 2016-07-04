//
//  PreviewWindowControllerDelegate.swift
//  NoteDemo
//
//  Created by Scotty on 03/07/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Foundation

protocol PreviewWindowControllerDelegate: class
{
    func closed(controller controller: PreviewWindowController)
}