//
//  CollectionViewItem.swift
//  MacScrobbler
//
//  Created by Rene Haavre on 06/11/2018.
//  Copyright © 2018 Rene Haavre. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {
        
    var imageFile: NSImage? {
        didSet {
            guard isViewLoaded else { return }
            if let imageFile = imageFile {
                imageView?.image = imageFile
            } else {
                imageView?.image = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
    }
    
}
