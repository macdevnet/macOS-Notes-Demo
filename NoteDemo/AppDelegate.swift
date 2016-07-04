//
//  AppDelegate.swift
//  NotesDemo
//
//  Created by Scotty on 30/06/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var appCoordinator: AppCoordinator!

    func applicationDidFinishLaunching(aNotification: NSNotification)
    {
        appCoordinator = AppCoordinator()
        appCoordinator.start()
    }

}

