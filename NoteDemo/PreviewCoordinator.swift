//
//  PreviewCoordinator.swift
//  NoteDemo
//
//  Created by Scotty on 02/07/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Foundation


class PreviewCoordinator: BaseCoordinator
{
    private var previewWindowController: PreviewWindowController?
    
    func start(id id: String, position: NSPoint, timeBasedDisplay: Bool = false)
    {
        previewWindowController = PreviewWindowController.createPreviewWindowController(focusPoint: position)
        previewWindowController?.dataProvider = DataProvider()
        previewWindowController?.focusPoint = position
        previewWindowController?.id = id
        previewWindowController?.showWindow(self)
        previewWindowController?.delegate = self
    }
}



extension PreviewCoordinator: PreviewWindowControllerDelegate
{
    func closed(controller controller: PreviewWindowController) {
        delegate?.done(coordinator: self)
        previewWindowController = nil
    }
}
