//
//  ViewController.swift
//  MacScrobbler
//
//  Created by Rene Haavre on 06/11/2018.
//  Copyright © 2018 Rene Haavre. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let apiKey = "REPLACE_ME"
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(NSNib(nibNamed: "CollectionViewItem", bundle: nil)!, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"))
        
        configureCollectionView()
    }
    
    fileprivate func configureCollectionView() {

        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 120.0, height: 120.0)
        collectionView.collectionViewLayout = flowLayout

        view.wantsLayer = true
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension ViewController: NSCollectionViewDataSource, NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath) as! CollectionViewItem
        item.imageFile = NSImage(named: "album.png")
        
        return item
    }
    
    
}

