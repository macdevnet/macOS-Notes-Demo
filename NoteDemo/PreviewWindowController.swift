//
//  PreviewWindowController.swift
//  NoteDemo
//
//  Created by Scotty on 01/07/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Cocoa


class PreviewWindowController: NSWindowController
{
    weak var delegate: PreviewWindowControllerDelegate?
    
    var dataProvider: NoteDataProvider?
    {
        willSet {
            dataProvider?.delegate = nil
        }
        didSet {
            dataProvider?.delegate = self
            loadNote()
        }
    }
    
    var id: String? {
        didSet {
            loadNote()
        }
    }

    var focusPoint: NSPoint?
}

extension PreviewWindowController
{
    override func showWindow(sender: AnyObject?) {
        
        if let window = window, focusPoint = focusPoint {
            var xAdjustment: CGFloat = 5
            let screenWidth = NSScreen.mainScreen()?.frame.width
            let endOfWindow = window.frame.size.width + focusPoint.x - xAdjustment
            if endOfWindow > screenWidth {
                xAdjustment += (endOfWindow - screenWidth!)
            }
            let windowPosition = NSPoint(x: focusPoint.x - xAdjustment, y: focusPoint.y - 5)
            window.setFrameOrigin(windowPosition)
        }

        super.showWindow(sender)
    }
    
    
    private func loadNote()
    {
        if let id = id {
            
            guard let previewViewController = window?.contentViewController as? PreviewViewController else {
                fatalError("PreviewViewController Cannot be found");
            }
            
            dataProvider?.note(id: id, completionHandler: { (note) in
                dispatch_async(dispatch_get_main_queue()) {
                    previewViewController.note = note
                    self.window?.setContentSize(NSMakeSize(400, previewViewController.suggestedHeight))
                }
            })
        }
    }
    
    
    override func close()
    {
        super.close()
        delegate?.closed(controller: self)
    }
    
}

extension PreviewWindowController: NoteDataProviderDelegate
{
    func noteChanged(id id: String)
    {
        guard let currentId = self.id where currentId == id else { return }
        loadNote()
    }
}



/// Class Functions
extension PreviewWindowController
{
    class func createPreviewWindowController(focusPoint focusPoint: NSPoint) -> PreviewWindowController?
    {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateControllerWithIdentifier("PreviewWindowController") as? PreviewWindowController
        controller?.focusPoint = focusPoint
        return controller
    }
}
