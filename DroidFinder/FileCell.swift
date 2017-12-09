//
//  FileCell.swift
//  DroidFinder
//
//  Created by Yoshihiro Tanaka on 2016/04/27.
//

import AppKit

class FileCell: NSBrowserCell {
    
    internal var currentPath: String = ""
    internal var fileName: String? = nil
   
    override func menu(for event: NSEvent, in cellFrame: NSRect, of view: NSView) -> NSMenu? {
        let menu = NSMenu(title: "")
        let item = NSMenuItem(title: "pull", action: #selector(FileCell.onClickPull), keyEquivalent: "P")
        item.target = self
        menu.addItem(item)
        menu.autoenablesItems = true
        return menu
    }
    
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        return menuItem.isEnabled
    }
    
    @objc func onClickPull() {
        if let home = CommandUtils.getHome() {
            let desktop = [home, "Desktop"].joined(separator: "/")
            if let fn = fileName {
                _ = CommandUtils.execCommand(["pull", [currentPath, fn].joined(separator: "/"), desktop])
            }
        }
    }
}
