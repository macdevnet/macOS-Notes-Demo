//
//  EditViewController.swift
//  NoteDemo
//
//  Created by Scotty on 02/07/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Cocoa

class EditViewController: NSViewController {
    
    
    @IBOutlet weak var titleField: NSTextField!
    @IBOutlet var contentField: NSTextView!
    @IBOutlet weak var saveButton: NSButton!
    
    private var loaded: Bool = false
    
    var controller: NoteEditController? {
        willSet {
            controller?.viewDelegate = nil
        }
        didSet {
            controller?.viewDelegate = self
            refreshDisplay()
        }
    }
}

/// Methods
extension EditViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        refreshDisplay()
    }
    
    
    private func refreshDisplay()
    {
        if let noteValues = controller?.noteValues {
            titleField.stringValue = noteValues.title
            let aString = noteValues.content
            contentField.textStorage?.setAttributedString(aString)
        } else {
            titleField.stringValue = ""
            contentField.textStorage?.setAttributedString(NSAttributedString(string: ""))
        }
        checkCanSaveValues()
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject)
    {
        saveNote()
    }
    
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        controller?.cancel()
    }
    
    
    override func validateMenuItem(menuItem: NSMenuItem) -> Bool
    {
        var enabled: Bool = false
        switch (menuItem.tag) {
            case MenuTag.SaveMenu.rawValue:
                return saveButton.enabled
            default:
                enabled = false
        }
        return enabled
    }
    
    
    private func saveNote()
    {
        controller?.updateNoteValues(title: titleField.stringValue, content: contentField.attributedString())
    }
    
    
    func saveDocument(sender: AnyObject)
    {
        saveNote()
    }
    
    
    func checkCanSaveValues()
    {
        guard let controller = controller else {
            saveButton.enabled = false
            return
        }
        
        saveButton.enabled = controller.canSaveNoteValues(title: titleField.stringValue, content: contentField.attributedString())
    }
}



extension EditViewController: NoteEditControllerViewDelegate
{
    func displayErrorMessage(editController editController: NoteEditController, message: String)
    {
        guard let window = view.window else { return}
        
        let alert = NSAlert()
        alert.addButtonWithTitle("OK")
        alert.messageText = message
        alert.alertStyle = .CriticalAlertStyle
        alert.beginSheetModalForWindow(window, completionHandler: nil)
    }
    
    
    func noteDidChange(editController editController: NoteEditController)
    {
        refreshDisplay()
    }
}



/// Watch the Text Fields
extension EditViewController: NSTextViewDelegate
{
    override func controlTextDidChange(obj: NSNotification)
    {
        checkCanSaveValues()
    }
    
    
    func textDidChange(notification: NSNotification) {
        checkCanSaveValues()
    }
}
