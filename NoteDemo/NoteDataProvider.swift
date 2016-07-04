//
//  NoteModel.swift
//  NoteDemo
//
//  Created by Scotty on 30/06/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Foundation

protocol NoteDataProviderDelegate: class
{
    func noteChanged(id id: String)
    func notesLoaded()
}



extension NoteDataProviderDelegate
{
    //? Dummy implementation to make the method sort of optional
    func notesLoaded(){}
}



protocol NoteDataProvider
{
    var delegate: NoteDataProviderDelegate? { get set }
    func notes(completionHandler: (notes: [Note]) -> Void)
    func note(id id: String, completionHandler: (note: Note?) -> Void)
    func saveNote(note: Note, completionHandler: (error: NSError?) -> ())
    
}
