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
    var username = ""
    var albumLimit = 50
    var isUpdating = false {
        didSet {
            if isUpdating {
                loadingView.layer?.backgroundColor = NSColor.init(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
                spinnerIndicator.startAnimation(self)
            }
            else {
                loadingView.layer?.backgroundColor = NSColor.clear.cgColor
                spinnerIndicator.stopAnimation(self)

            }
        }
    }
    
    var albumsArray = [Album]()
    var albumImagesArray = [NSImage]()
    
    @IBOutlet var spinnerIndicator: NSProgressIndicator!
    @IBOutlet var loadingView: NSView!
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet var usernameTextField: NSTextField!
    
    @IBAction func albumCountSelectedAction(_ sender: NSSegmentedControl) {
        albumLimit = Int(sender.label(forSegment: sender.selectedSegment)!) ?? 50
        getJSON()
    }
    
    @IBAction func reloadAction(_ sender: NSButton) {
        
        albumImagesArray.removeAll()
        albumsArray.removeAll()
        getJSON()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        spinnerIndicator.isIndeterminate = false
        spinnerIndicator.style = .spinning

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
        
        isUpdating = true
        spinnerIndicator.isHidden = false
        spinnerIndicator.maxValue = Double(self.albumLimit)
        
        username = usernameTextField.stringValue

        guard let url = URL(string: "http://ws.audioscrobbler.com/2.0/?method=user.gettopalbums&user=" + username + "&api_key=" + apiKey + "&format=json&limit=" + String(albumLimit)) else { return }
        print(url)
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {

                
                guard let json = try? JSON(data: data) else { return }
                print("DEBUG: We have the JSON, building albumsArray with \(self.albumLimit) items.")
                
                for i in 0..<self.albumLimit {
                    DispatchQueue.main.async {
                        self.spinnerIndicator.doubleValue = Double(i)
                        print("Progress:", Double(i))
                        if i == (self.albumLimit - 1) {
                            self.spinnerIndicator.isHidden = true
                        }
                    }
                    
                    let JSONAlbumRef = json["topalbums"]["album"][i]
                    
                    let album = Album(name: JSONAlbumRef["name"].stringValue, artist: JSONAlbumRef["artist"]["name"].stringValue, coverURL: JSONAlbumRef["image"][2]["#text"].stringValue, playCount: JSONAlbumRef["playcount"].intValue)
                    self.albumsArray.append(album)
                    
                    // If album cover URL is missing, display the default one
                    if JSONAlbumRef["image"][2]["#text"].stringValue == "" {
                        self.albumImagesArray.append(NSImage(named: "defaultAlbum.png")!)
                    } else {
                        self.albumImagesArray.append(NSImage(byReferencing: URL(string: JSONAlbumRef["image"][2]["#text"].stringValue)!))
                    }
                    
                }
                
            }
            
            DispatchQueue.main.async {
                print("DEBUG: Finished building albumsArray, updating data now...")
                self.collectionView.reloadData()
                print("DEBUG: Data updated.")
                self.isUpdating = false
            }
        }.resume()
        
    }


}

extension ViewController: NSCollectionViewDataSource, NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumsArray.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath)
        guard let collectionViewItem = item as? CollectionViewItem else {return item}
        
        collectionViewItem.imageFile = albumImagesArray[indexPath.item]
        
        return item
    }
    
    
}

