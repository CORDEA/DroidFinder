//
//  FileBrowser.swift
//  DroidFinder
//
//  Created by Yoshihiro Tanaka on 2016/05/06.
//

import AppKit

protocol FileBrowserDelegate : class {
    func onClickReload()
}

class FileBrowser : NSBrowser {
    
    weak var fileDelegate: FileBrowserDelegate?

    override func menu(for event: NSEvent) -> NSMenu? {
        let menu = NSMenu(title: "")
        let item = NSMenuItem(title: "reload", action: #selector(FileBrowser.onClickReload), keyEquivalent: "")
        item.target = self
        menu.addItem(item)
        return menu
    }
    
    @objc func onClickReload() {
        fileDelegate?.onClickReload()
    }
}
