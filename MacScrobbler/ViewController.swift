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
    let username = "renehaavre"
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(NSNib(nibNamed: "CollectionViewItem", bundle: nil)!, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"))
        
        configureCollectionView()
        getJSON()
    }
    
    fileprivate func configureCollectionView() {

        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 120.0, height: 120.0)
        collectionView.collectionViewLayout = flowLayout

        view.wantsLayer = true
    }

    func getJSON() {
        
        guard let url = URL(string: "http://ws.audioscrobbler.com/2.0/?method=user.gettopalbums&user=" + username + "&api_key=" + apiKey + "=json") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                print(data)
            }
            
            if let response = response {
                print(response.debugDescription)
            }
        }.resume()
        
        
    }


}

extension ViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath)
        guard let collectionViewItem = item as? CollectionViewItem else {return item}
        
        let imageFile = NSImage(named: "album.png")
        collectionViewItem.imageFile = imageFile
        return item
    }
    
    
}

