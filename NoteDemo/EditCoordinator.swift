//
//  EditCoordinator.swift
//  NoteDemo
//
//  Created by Scotty on 02/07/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Cocoa


class EditCoordinator: BaseCoordinator
{
    private var editWindowController: NSWindowController?
    
    func edit(id id: String)
    {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        editWindowController = storyboard.instantiateControllerWithIdentifier("EditWindowController") as? NSWindowController
        guard let editWindowController = editWindowController else {
            fatalError("The Edit Window Controller Cannot be found");
        }
        guard let editViewController = editWindowController.window?.contentViewController as? EditViewController else {
            fatalError("The Edit View Controller Cannot be found");
        }
        
        let editController = EditController(id: id)
        editController.dataProvider = DataProvider()
        editController.coordinatorDelegate = self
 
        editViewController.controller = editController
        editWindowController.showWindow(self)
    }
    
    
    func focus()
    {
        editWindowController?.window?.makeKeyAndOrderFront(self)
    }
}



extension EditCoordinator: NoteEditControllerCoordinatorDelegate
{
    func noteEditControllerDone(controller controller: NoteEditController)
    {
        editWindowController?.close()
        editWindowController = nil
        done()
    }
}

