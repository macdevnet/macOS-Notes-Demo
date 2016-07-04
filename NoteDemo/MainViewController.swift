//
//  ViewController.swift
//  NoteDemo
//
//  Created by Scotty on 30/06/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    static let collectionCellIdentifier = "NoteItemCell"

    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var addButton: NSButton!
    
    var lastPreviewIndex: Int = -1

    var controller: NoteMainController? {
        willSet {
            controller?.viewDelegate = nil
        }
        didSet {
            controller?.viewDelegate = self
            refreshDisplay()
        }
    }
}



///Methods
extension MainViewController
{

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }

    
    private func refreshDisplay()
    {
        collectionView.reloadData()
    }
 
    
    private func setUpCollectionView()
    {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 400.0, height: 220.0)
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 5.0
        flowLayout.minimumLineSpacing = 10.0
        collectionView.collectionViewLayout = flowLayout
        view.wantsLayer = true
    }

    private func updateSelection(indexPaths: Set<NSIndexPath>)
    {
        for indexPath in indexPaths {
            if let note = collectionView.itemAtIndexPath(indexPath) as? NoteCollectionViewItem {
                note.refreshDisplay()
                lastPreviewIndex = indexPath.item
            }
        }
    }
    
    
    private func editNote(index index: Int)
    {
        guard let controller = controller else { return }
        lastPreviewIndex = index
        controller.editNote(index: index)
    }
}



/// Menu Methods
extension MainViewController
{
    // Handles the + button and the "New" Menu Item
    @IBAction func newDocument(sender: AnyObject)
    {
        controller?.newNote()
    }
    
    
    @IBAction func openDocument(sender: AnyObject)
    {
        for selectedIndex in collectionView.selectionIndexes {
            editNote(index: selectedIndex)
        }
    }
    
    
    override func validateMenuItem(menuItem: NSMenuItem) -> Bool
    {
        switch (menuItem.tag) {
            case MenuTag.NewMenu.rawValue:
                return true
            case MenuTag.OpenMenu.rawValue:
                return collectionView.selectionIndexes.count > 0
            default:
                return false
        }
    }
}



/// Handle methods delegated from the controller
extension MainViewController: NoteMainControllerViewDelegate
{
    func notesDidChange(controller controller: NoteMainController)
    {
        refreshDisplay()
    }
}



extension MainViewController: NSCollectionViewDataSource
{
    func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let controller = controller else { return 0 }
        return controller.numberOfNotes
    }
    
    
    func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItemWithIdentifier("NoteCollectionViewItem", forIndexPath: indexPath)
        
        if let item = item as? NoteCollectionViewItem {
            if let data = controller?.note(index: indexPath.item) {
                item.index = indexPath.item
                item.delegate = self
                item.note = data
            }
        }
        
        return item
    }
}



extension MainViewController: NSCollectionViewDelegate
{
    func collectionView(collectionView: NSCollectionView, didSelectItemsAtIndexPaths indexPaths: Set<NSIndexPath>)
    {
        updateSelection(indexPaths)
    }
    
    
    func collectionView(collectionView: NSCollectionView, didDeselectItemsAtIndexPaths indexPaths: Set<NSIndexPath>)
    {
        updateSelection(indexPaths)
    }
}



extension MainViewController: NoteCollectionViewItemDelegate
{
    func hover(collectionItem collectionItem: NoteCollectionViewItem, position: NSPoint)
    {
        let index = collectionItem.index
        guard lastPreviewIndex != index else { return }
        lastPreviewIndex = index

        controller?.previewNote(index: collectionItem.index, position: position)
    }
    
    
    func doubleClicked(collectionItem collectionItem: NoteCollectionViewItem)
    {
        editNote(index: collectionItem.index)
    }
}
