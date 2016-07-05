//
//  MenuTags.swift
//  NoteDemo
//
//  Created by Scotty on 04/07/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Foundation


/// Used to make identifiying MenuItems a little easier to read in code.
/// Menu Items should have their Tag value set to the corresponding value
enum MenuTag: Int {
    case NewMenu = 100
    case OpenMenu = 110
    case SaveMenu = 120
    case ShowFonts = 300
}
