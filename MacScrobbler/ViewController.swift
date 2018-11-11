//
//  ViewController.swift
//  MacScrobbler
//
//  Created by Rene Haavre on 06/11/2018.
//  Copyright © 2018 Rene Haavre. All rights reserved.
//

import Cocoa

struct Album {
    let name: String
    let artist: String
    let coverURL: String
    let playCount: Int
}

class ViewController: NSViewController {

    let apiKey = "REPLACE_ME"
    let username = "renehaavre"
    let albumLimit = 50
    
    var albumsArray = [Album]()
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    @IBAction func reloadAction(_ sender: NSButton) {
        collectionView.reloadData()
    }
    
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
        
        guard let url = URL(string: "http://ws.audioscrobbler.com/2.0/?method=user.gettopalbums&user=" + username + "&api_key=" + apiKey + "&format=json&limit=" + String(albumLimit)) else { return }
        print(url)
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {

                
                guard let json = try? JSON(data: data) else { return }

                for i in 0..<self.albumLimit {
                    let JSONAlbumRef = json["topalbums"]["album"][i]

//                    print(json["topalbums"]["album"][i]["name"])
//                    print(json["topalbums"]["album"][i]["image"][3]["#text"])
//                    print(json["topalbums"]["album"][i]["playcount"])
                    
                    
                    let album = Album(name: JSONAlbumRef["name"].stringValue, artist: JSONAlbumRef["artist"]["name"].stringValue, coverURL: JSONAlbumRef["image"][3]["#text"].stringValue, playCount: JSONAlbumRef["playcount"].intValue)
                    self.albumsArray.append(album)
                }
                
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }.resume()
        
    }

}

extension ViewController: NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumsArray.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath)
        guard let collectionViewItem = item as? CollectionViewItem else {return item}
        
        let imageURL = URL(string: albumsArray[indexPath.item].coverURL)
        var imageFile = NSImage()
        
        if let imageURL = imageURL {
            imageFile = NSImage(byReferencing: imageURL)
        } else {
            imageFile = NSImage(named: "album.png")!
        }
        
        collectionViewItem.imageFile = imageFile
        
        return item
    }
    
    
}

