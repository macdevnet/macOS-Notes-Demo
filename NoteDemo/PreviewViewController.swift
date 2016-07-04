//
//  PreviewViewController.swift
//  NoteDemo
//
//  Created by Scotty on 01/07/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Cocoa

class PreviewViewController: NSViewController {

 
    @IBOutlet weak var titleField: NSTextField!
    @IBOutlet weak var contentField: NSTextField!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    
    var suggestedHeight: CGFloat  {
        return titleHeightConstraint.constant + contentHeightConstraint.constant + 20
    }
    
    var note: Note? {
        didSet {
            refreshDisplay()
        }
    }
}


/// Methods
extension PreviewViewController
{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true 
        view.layer?.backgroundColor = NSColor(red:0.98, green:0.98, blue:0.98, alpha:1.00).CGColor
        view.layer?.cornerRadius = 10.0
        view.layer?.borderColor = NSColor(red:0.95, green:0.95, blue:0.95, alpha:1.00).CGColor
        view.layer?.borderWidth = 1.0

        let trackingArea = NSTrackingArea(rect: view.bounds,
                                          options: [NSTrackingAreaOptions.ActiveAlways,NSTrackingAreaOptions.MouseEnteredAndExited],
                                          owner: self, userInfo: nil)
        view.addTrackingArea(trackingArea)
    }
    
    /// Fade in the window
    override func viewDidAppear() {
        NSAnimationContext.runAnimationGroup({ (context: NSAnimationContext!) in
            context.duration = 0.25
            self.view.window?.animator().alphaValue = 0.9
            }, completionHandler: nil
        )
    }

    
    /// When the mouse exits the view fade and then close the window
    override func mouseExited(theEvent: NSEvent)
    {
        NSAnimationContext.runAnimationGroup({ (context: NSAnimationContext!) in
            context.duration = 0.25
            self.view.window?.animator().alphaValue = 0
            }, completionHandler: {
                self.view.window?.windowController?.close()
        })
    }
    
    
    func refreshDisplay() {
        if let note = note {
            titleField.stringValue = note.title
            let aString = note.content
            contentField.attributedStringValue = aString
        } else {
            titleField.stringValue = ""
            contentField.attributedStringValue = NSAttributedString(string:"")
        }
        
        calculateSize()
        self.view.layoutSubtreeIfNeeded()
    }
    
    
    private func calculateSize()
    {
        titleHeightConstraint.constant += calculateHeight(string: titleField.attributedStringValue.string, font: titleField.font!)
        contentHeightConstraint.constant += calculateHeight(string: contentField.attributedStringValue.string, font: contentField.font!)
        
    }
    
    
    private func calculateHeight(string string: String, font: NSFont) -> CGFloat
    {
        let size = NSMakeSize(400, CGFloat(FLT_MAX))
        let textStorage = NSTextStorage(string: string)
        let textContainer = NSTextContainer(size: size)
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textStorage.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, textStorage.length))
        textContainer.lineFragmentPadding = 0.0
        layoutManager.glyphRangeForTextContainer(textContainer)
        return layoutManager.usedRectForTextContainer(textContainer).size.height
    }
}
