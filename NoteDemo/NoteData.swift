//
//  File.swift
//  NoteDemo
//
//  Created by Scotty on 30/06/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Foundation

struct NoteData: Note
{
    static func newNoteData() -> NoteData
    {
        return NoteData(id: NSUUID().UUIDString, title: "New Note", content: NSAttributedString(string:""))
    }
    
    private(set) var id: String
    private(set) var title: String
    private(set) var content: NSAttributedString
    
    init(id: String, title: String, content: NSAttributedString)
    {
        self.title = title
        self.content = content
        self.id = id
    }
}
