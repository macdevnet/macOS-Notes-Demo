//
//  PreviewWindow.swift
//  NoteDemo
//
//  Created by Scotty on 01/07/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Cocoa

class PreviewWindow: NSWindow
{
    override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, defer flag: Bool)
    {
        super.init(contentRect: contentRect, styleMask: NSBorderlessWindowMask, backing:NSBackingStoreType.Buffered, defer: true)
        alphaValue = 0
        opaque = false
        backgroundColor = NSColor.clearColor()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
}
