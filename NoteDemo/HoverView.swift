//
//  HoverView.swift
//  NoteDemo
//
//  Created by Scotty on 01/07/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Cocoa

protocol HoverViewDelegate: class
{
    func hover(view view: HoverView, position: NSPoint)
    func doubleClick(view view: HoverView)
}

class HoverView: NSView
{
    var trackingArea: NSTrackingArea?
    var hovering = false
    var timer: NSTimer?
    weak var delegate: HoverViewDelegate?
    var mousePosition: NSPoint?
}


/// Methods
extension HoverView
{
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        ensureTrackingArea()
        if !trackingAreas.contains(trackingArea!) {
            addTrackingArea(trackingArea!)
        }
    }
    
    
    func ensureTrackingArea()
    {
        guard trackingArea == nil else { return }
        trackingArea = NSTrackingArea(rect: NSZeroRect, options: [NSTrackingAreaOptions.InVisibleRect, NSTrackingAreaOptions.ActiveAlways, NSTrackingAreaOptions.MouseEnteredAndExited, NSTrackingAreaOptions.MouseMoved], owner: self, userInfo: nil)
    }
    
    
    private func cycleTimer()
    {
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target:self, selector: #selector(hover), userInfo: nil, repeats: false)
    }
    
    
    override func mouseEntered(theEvent: NSEvent)
    {
        cycleTimer()
    }
    
    
    override func mouseMoved(theEvent: NSEvent)
    {
        if timer != nil {
            cycleTimer()
        }
        mousePosition = NSEvent.mouseLocation()
    }
    
    
    override func mouseExited(theEvent: NSEvent)
    {
        timer?.invalidate()
        timer = nil
        hovering = false
    }
    
    
    override func mouseDown(theEvent: NSEvent)
    {
        let count = theEvent.clickCount
        if (count == 2) {
            delegate?.doubleClick(view: self)
        } else {
            super.mouseDown(theEvent)
        }
    }
    
    
    func hover()
    {
        hovering = true
        if let position = mousePosition {
            delegate?.hover(view: self, position: position)
        }
    }
}
