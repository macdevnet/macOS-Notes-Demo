//
//  BaseCoordinator.swift
//  NotesDemo
//
//  Created by Scotty on 02/07/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Foundation

protocol Coordinator
{
    var key: String { get }
}

protocol CoordinatorDelegate: class
{
    func done(coordinator coordinator: Coordinator)
}


class BaseCoordinator: Coordinator
{
    var key = NSUUID().UUIDString
    weak var delegate: CoordinatorDelegate?
    
    func done()
    {
        delegate?.done(coordinator: self)
    }
}