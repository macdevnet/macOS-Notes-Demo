//
//  NoteCollectionViewItem.swift
//  NoteDemo
//
//  Created by Scotty on 30/06/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Cocoa

protocol NoteCollectionViewItemDelegate: class
{
    func hover(collectionItem collectionItem: NoteCollectionViewItem ,position: NSPoint)
    func doubleClicked(collectionItem collectionItem: NoteCollectionViewItem)
}

class NoteCollectionViewItem: NSCollectionViewItem
{
    @IBOutlet weak var titleField: NSTextField!
    @IBOutlet weak var contentField: NSTextField!
    
    weak var delegate: NoteCollectionViewItemDelegate?
    
    var index: Int = 0
    
    var note: Note? {
        didSet {
            refreshDisplay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        titleField.preferredMaxLayoutWidth = titleField.frame.size.width
        
        if let view = view as? HoverView {
            view.delegate = self
        }
    }
}



/// Display Functions
extension NoteCollectionViewItem
{
    func refreshDisplay()
    {
        setColors()
        if let note = note {
            titleField.stringValue = note.title
            let aString = note.content
            contentField.attributedStringValue = aString
        } else {
            titleField.stringValue = ""
            contentField.attributedStringValue = NSAttributedString(string:"")
        }
    }
    
    
    private func setColors()
    {
        view.layer?.backgroundColor = NSColor(red:0.98, green:0.98, blue:0.98, alpha:1.00).CGColor
        view.layer?.cornerRadius = 10.0
        
        if selected {
            view.layer?.borderColor = NSColor(red:0.24, green:0.44, blue:0.63, alpha:1.00).CGColor
            view.layer?.borderWidth = 2.0
        } else {
            view.layer?.borderColor = NSColor(red:0.95, green:0.95, blue:0.95, alpha:1.00).CGColor
            view.layer?.borderWidth = 1.0
        }
    }
}


/// HoverView Delegate
extension NoteCollectionViewItem: HoverViewDelegate
{
    func hover(view view: HoverView, position: NSPoint)
    {
        delegate?.hover(collectionItem: self, position: position)
    }
    
    func doubleClick(view view: HoverView)
    {
        delegate?.doubleClicked(collectionItem: self)
    }
}


