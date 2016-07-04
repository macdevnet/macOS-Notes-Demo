# Note Demo macOS Application

### Overview

This application is intended to be used as a macOS (OSX) sample application.
It is intended to be used to demonstrate a number of Cocoa good practices and techniques including

+ Separation of concerns using MVC
+ Window Handling
+ Mouse Handling
+ Menu Handling
+ Keyboard Handling
+ Basic Multi-Threading using GCD
+ Protecting shared resources using Semaphores 

## Language

The code is written using Swift 2.2.

Methods have been named using the newer swift style of not including the first parameter as part of the method name.
To make code more readable when using this format I also force the first parameter to be a named parameter in functions.

```swift
func myFunction(internalNameOne internalNameOne: Int, externalNameTwo internalNameTwo: Int) {}
myFunction(internalNameOne: 1, externalNameTwo: 2)
``` 

## Current Status

The application is currently incomplete. 
Things still to do.

+ The application UI is very basic and could do with a lot of polish
+ The application menu structure is pretty much as Xcode creates it. Each menu item needs to be reviewed and either hooked up or deleted.
+ There is very little error handling in the application. There are a number of ```//TODO:``` comments where errors need to be created and raised.
+ Edit Windows are not positioned correctly
+ There are still one or two display glitches when you hover the mouse over note. 
+ The app uses JSON files in the ~/Documents folder as its data. These are all currently loaded into memory. The app needs to be updated to use Core Data as its data store. 
+ Although the code should hopefully be quite readable, it could really do with far more commenting to be good sample/tutorial code.


## Warning

This code is still very Alpha but hopefully already contains enough substance to be a useful learning tool


## License 

This code is available for use under the MIT License.

## The MIT License

Copyright (c) 2010-2016 Google, Inc. http://angularjs.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.