//
//  File.swift
//  NotesDemo
//
//  Created by Scotty on 30/06/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Cocoa

/// The AppCoordinator controls the main flow of the application
class AppCoordinator
{
    
    private var mainWindowController: NSWindowController!
    private var window:  NSWindow!
    private var coordinators = [String:Coordinator]()
    
    func start()
    {
        setupMainViewControllerStack()
    }
    
    
    private func setupMainViewControllerStack()
    {
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        mainWindowController = storyboard.instantiateControllerWithIdentifier("MainWindowController") as? NSWindowController
        window = mainWindowController.window
        
        guard let mainViewController = window.contentViewController as? MainViewController else {
            fatalError("The Main View Controller Cannot be found");
        }
        
        let mainController = MainController()
        mainController.dataProvider = DataProvider()
        mainController.coordinatorDelegate = self
        
        mainViewController.controller = mainController
        mainWindowController.showWindow(self)
    }
}



extension AppCoordinator: NoteMainControllerCoordinatorDelegate
{
    func newNote()
    {
        editNote(id: NSUUID().UUIDString)
    }

    
    func editNote(id id: String)
    {
        
        guard let editCoordinator =  coordinators[id] as? EditCoordinator  else {
            
            let coordinator = EditCoordinator()
            coordinator.delegate = self
            coordinator.edit(id: id)
            coordinator.key = id
            coordinators[id] = coordinator
            return
        }
        
        editCoordinator.focus()
    }
    
    
    func previewNote(id id: String, position: NSPoint, timeBasedDisplay: Bool = false)
    {
        let previewCoordinator = PreviewCoordinator()
        previewCoordinator.delegate = self
        previewCoordinator.start(id: id, position: position, timeBasedDisplay: timeBasedDisplay)
        coordinators[previewCoordinator.key] = previewCoordinator
    }
}



extension AppCoordinator: CoordinatorDelegate
{
    func done(coordinator coordinator: Coordinator)
    {
        coordinators.removeValueForKey(coordinator.key)
    }
}

