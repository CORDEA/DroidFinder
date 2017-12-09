//
//  ViewController.swift
//  DroidFinder
//
//  Created by Yoshihiro Tanaka on 2016/04/26.
//

import Cocoa

class ViewController: NSViewController, NSBrowserDelegate, FileBrowserDelegate {

    @IBOutlet weak var browser: FileBrowser!
    
    private var dirs: [[File]] = []
    private var recentPath: [String] = []
    
    override func awakeFromNib() {
        browser.setCellClass(FileCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        browser.delegate = self
        browser.fileDelegate = self
        browser.maxVisibleColumns = 2
 
        switch connectedDevices() {
        case 0:
            let alert = NSAlert()
            alert.addButton(withTitle: "OK")
            alert.messageText = "Device is not connected"
            alert.informativeText = "Please connect device."
            alert.runModal()
            break
        case 1:
            recentPath = ["."]
            dirs.append(ls())
            break
        case 2:
            let alert = NSAlert()
            alert.addButton(withTitle: "OK")
            alert.messageText = "Multiple devices are connected"
            alert.informativeText = "Please confirm there is only one device connected."
            alert.runModal()
            break
        default:
            break
        }
    }
    
    @IBAction func onClickCell(_ sender: NSBrowser) {
        let column = browser.selectedColumn
        let row = browser.selectedRow(inColumn: column)
        if column < 0 || row < 0 {
            return
        }
        let item = dirs[column][row]
        
        if item.filetype == FileType.directory {
            if (column + 1) >= dirs.count {
                recentPath.append(item.filename)
                dirs.append(ls())
            } else {
                dirs[column + 1] = []
                recentPath = Array(recentPath[0..<(column + 1)])
                recentPath.append(item.filename)
                dirs[column + 1] = ls()
            }
            browser.reloadColumn(column + 1)
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private func getCurrentPath() -> String {
        var path = recentPath.joined(separator: "/")
        if !path.hasSuffix("/") {
            path += "/"
        }
        return path
    }
    
    private func connectedDevices() -> Int {
        let devices = CommandUtils.execCommand(["devices"])
        let lines = devices?.components(separatedBy: "\n").count
        if let n = lines {
            return n - 3
        }
        return 0
    }
    
    private func ls() -> [File] {
        var outputs: [File] = []
        let path = getCurrentPath()
        let lsoutput = CommandUtils.execCommand(["shell", "ls", path])
        let lloutput = CommandUtils.execCommand(["shell", "ls", "-l", path])
        if let ls = lsoutput?.components(separatedBy: "\n") {
            if let ll = lloutput?.components(separatedBy: "\n") {
                for (i, file) in ll.enumerated() {
                    if !file.isEmpty {
                        var fileType = FileType.file
                        let mode = (file as NSString).substring(to: 1)
                        if mode == "d" || mode == "l" {
                            fileType = FileType.directory
                        }
                        outputs.append(File(filetype: fileType, filename: ls[i], hasPermission: checkPermission(file as NSString)))
                    }
                }
            }
        }
        return outputs
    }
    
    private func checkPermission(_ output: NSString?) -> Bool {
        if let userPermit = output?.components(separatedBy: " ") {
            if userPermit[1] == "system" {
                return false
            }
        }
        if let filePermit = output?.substring(with: NSRange(location: 4, length: 3)) {
            if filePermit == "---" {
                return false
            }
        }
        return true
    }
   
    func browser(_ sender: NSBrowser, numberOfRowsInColumn column: Int) -> Int {
        if column < dirs.count {
            return dirs[column].count
        }
        return 0
    }
    
    func browser(_ browser: NSBrowser, numberOfChildrenOfItem item: Any?) -> Int {
        return 0
    }
    
    func browser(_ sender: NSBrowser, willDisplayCell cell: Any, atRow row: Int, column: Int) {
        if let c = cell as? FileCell {
            if column < dirs.count {
                if row < dirs[column].count {
                    c.currentPath = getCurrentPath()
                    let fileName = dirs[column][row].filename
                    c.stringValue = fileName
                    if dirs[column][row].filetype == FileType.file {
                        c.isLeaf = true
                        c.fileName = fileName
                    }
                    c.isEnabled = dirs[column][row].hasPermission
                }
            }
        }
    }
    
    func onClickReload() {
        let col = browser.selectedColumn + 1
        for i in 0...col {
            browser.reloadColumn(i)
        }
    }
}

