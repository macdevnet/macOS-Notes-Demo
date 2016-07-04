//
//  Note.swift
//  NoteDemo
//
//  Created by Scotty on 30/06/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Foundation

protocol Note
{
    var id: String { get }
    var title: String {get}
    var content: NSAttributedString {get}
}
