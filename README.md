# Note Demo macOS Application

### Overview

This application is intended to be used as a macOS (OSX) sample application used to demonstrate a number of Cocoa good practices and techniques including

+ Separation of concerns using MVC
+ Window Handling
+ Mouse Handling
+ Menu Handling
+ Keyboard Handling
+ Basic Multi-Treading using GCD
+ Protecting shared resources using Semaphores 

## Language

The code is written using Swift 2.2.

Methods have been named using the newer swift style of not including the first parameter as part of the method name.
To make code more readable when using this format I also force the first parameter to be a named parameter functions.

```swift
func myFunction(internalNameOne internalNameOne: Int, externalNameTwo internalNameTwo: Int) {}
myFunction(internalNameOne: 1, externalNameTwo: 2)
``` 

## Current Status

The application is currently incomplete. 
The first thing to finish are

+ The application UI is very basic and could do with a lot of polish
+ The Application Menu structure is pretty much as Xcode creates it. Each menu item needs to be reviewed and either hooked up or deleted.
+ There is very little error handling in the application. There are a number of //TODO: comments where errors need to be created and raised.
+ Edit Windows are not positioned correctly
+ There are still one or two display glitches when you hover the mouse over note. 
+ The app uses JSON files on the ~/Documents folder as it's data. These are all currently loaded into memory. The app needs to be updated to use Core Data as it's data store. 
+ Although the code should hopefully be quite readable, it could really do with far more commenting to be good sample/tutorial code.


## Warning

This code is still very Alpha but hopefully already contains enough substance to be a useful learning tool