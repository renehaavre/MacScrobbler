//
//  WindowController.swift
//  MacScrobbler
//
//  Created by Rene Haavre on 11/11/2018.
//  Copyright © 2018 Rene Haavre. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        window?.titleVisibility = .hidden
        window?.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
    }

}
