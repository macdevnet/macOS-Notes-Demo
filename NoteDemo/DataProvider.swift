//
//  DataProvider.swift
//  NotesDemo
//
//  Created by Scotty on 30/06/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//


// This data provider is designed for demo purposes and to demonstare certain techniques
// It would not work very well with large amounts of data as it keeps all the data in memory
// and sequentially looks through data when seraching for individual notes
// a better solution for large amounts of data would be a data store such as Core Data

import Cocoa

private let kNoteChangedNotification = "kNoteChangedNotification"
private let kNotesLoadedNotification = "kNotesLoadedNotification"


class DataProvider: NoteDataProvider
{
    
    private static let fileExtension = ".noteJSON"
    private static var notesLoading = false
    private static var notesLoaded = false
    private static let notesLock = dispatch_semaphore_create(1)
    private static let timeout: dispatch_time_t = DISPATCH_TIME_FOREVER
    private static var notes = [String:Note]()
    
    var delegate: NoteDataProviderDelegate?
    
    private lazy var documentPath: String? = {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        if let path = paths.first {
            return path + "/"
        } else {
            return nil
        }
    }()
    
    init()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DataProvider.noteChangedNotificationReceived(_:)), name: kNoteChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DataProvider.notesLoadedNotificationReceived(_:)), name: kNotesLoadedNotification, object: nil)
        loadNotes()
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}



/// Public Data Access Methods
extension DataProvider
{
    func notes(completionHandler: (notes: [Note]) -> Void)
    {
        dispatch_semaphore_wait(DataProvider.notesLock, DataProvider.timeout)
        let notes = Array(DataProvider.notes.values)
        dispatch_semaphore_signal(DataProvider.notesLock)
        completionHandler(notes: notes)
    }
    
    
    func note(id id: String, completionHandler: (note: Note?) -> Void)
    {
        dispatch_semaphore_wait(DataProvider.notesLock, DataProvider.timeout)
        let note = DataProvider.notes[id]
        dispatch_semaphore_signal(DataProvider.notesLock)
        completionHandler(note: note)
    }
    
    
    func saveNote(note: Note, completionHandler: (error: NSError?) -> ())
    {
        saveNoteToFile(note) { (error) in
            
            if error == nil {
                dispatch_semaphore_wait(DataProvider.notesLock, DataProvider.timeout)
                DataProvider.notes[note.id] = note
                dispatch_semaphore_signal(DataProvider.notesLock)
            }
            
            // Allow the completion handler to fire before letting all the other DataProviders know the data has changed
            completionHandler(error: error)
            
            if error == nil {
                NSNotificationCenter.defaultCenter().postNotificationName(kNoteChangedNotification, object: self, userInfo: ["id":note.id])
            }
            
        }
    }
}



/// Notification Handlers
extension DataProvider
{
    @objc func noteChangedNotificationReceived(notificiation: NSNotification)
    {
        if let userInfo = notificiation.userInfo, id = userInfo["id"] as? String {
            delegate?.noteChanged(id: id)
        }
    }
    
    
    @objc func notesLoadedNotificationReceived(notificiation: NSNotification)
    {
        delegate?.notesLoaded()
    }
}



/// Methods for handling reading notes from file and saving them to file
extension DataProvider
{
    private func loadNotes()
    {
        guard !DataProvider.notesLoaded && !DataProvider.notesLoading else { return }
        
        DataProvider.notesLoading = true
        
        // Ensure we have exclusive access to the Notes Dictionary
        loadNoteFiles { (notes) in
            
            var noteDictionary = [String:Note]()
            for note in notes {
                noteDictionary[note.id] = note
            }
            
            dispatch_semaphore_wait(DataProvider.notesLock, DataProvider.timeout)
            DataProvider.notes = noteDictionary
            dispatch_semaphore_signal(DataProvider.notesLock)
            DataProvider.notesLoading = false
            DataProvider.notesLoaded = true
            NSNotificationCenter.defaultCenter().postNotificationName(kNotesLoadedNotification, object: self, userInfo: nil)
        }
    }
    
    
    private func loadNoteFiles(completionHandler: (notes: [Note]) -> Void)
    {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            var notes = [Note]()
            if let path = self.documentPath {
                let fs: NSFileManager = NSFileManager.defaultManager()
                do {
                    let contents: Array = try fs.contentsOfDirectoryAtPath(path)
                    for fileName in contents {
                        if fileName.hasSuffix(DataProvider.fileExtension) {
                            do {
                                if let note = try self.loadNoteFromFile(fileName: fileName) {
                                    notes.append(note)
                                }
                            } catch let error as NSError {
                                NSLog("Error \(error)")
                            }
                        }
                    }
                } catch let error as NSError {
                    NSLog("Error \(error)")
                }
                completionHandler(notes: notes)
            }
        }
    }
    
    
    private func loadNoteFromFile(fileName fileName: String) throws -> Note?
    {
        guard let documentPath = documentPath else { return nil}
        
        var result: Note?
        let filePath = documentPath + fileName
        
        let jsonData = try NSData(contentsOfURL: NSURL(fileURLWithPath: filePath), options: NSDataReadingOptions.DataReadingMappedIfSafe)
        let object = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments)
        if let dictionary = object as? [String: AnyObject] {
            result =  makeNoteFromJSON(dictionary)
        }
        return result
    }
    
    
    private func saveNoteToFile(note: Note, completionHandler: (error: NSError?) -> ())
    {
        //TODO: Create Error
        guard let documentPath = documentPath else {
            completionHandler(error: nil)
            return
        }
        
        // Extract the note content from it's attributed string as RTF
        //TODO: Create Error
        guard let data = note.content.RTFFromRange(NSMakeRange(0, note.content.length), documentAttributes: [:])  else {
            completionHandler(error: nil)
            return
        }
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            //convert the RTF to base64 - just makes less issues when storing the content as JSON
            let base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            
            // Create a dictionary from the note that can then be converted to JSON
            var dictionary = [String:String]()
            dictionary["id"] = note.id
            dictionary["title"] = note.title
            dictionary["content"] = base64String
            
            // Turn the dictionary into JSON data then a JSON String.
            do {
                let jsonData = try NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions())
                let jsonString = String(data: jsonData, encoding: NSUTF8StringEncoding)
                let filePath = documentPath + note.id + DataProvider.fileExtension
                try jsonString?.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
                completionHandler(error: nil)
            } catch let error as NSError {
                completionHandler(error: error)
            }
        }
    }
    
    
    private func makeNoteFromJSON(object: [String: AnyObject]) -> Note?
    {
        guard let id = object["id"] as? String,
            title = object["title"] as? String,
            content = object["content"] as? String,
            decodedData = NSData(base64EncodedString: content, options: NSDataBase64DecodingOptions(rawValue: 0)),
            attributedcontent = NSAttributedString(RTF: decodedData, documentAttributes: nil)
            else {
                return nil
        }
        
        return NoteData(id: id, title: title, content: attributedcontent)
    }
}
