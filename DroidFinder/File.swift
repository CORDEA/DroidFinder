//
//  File.swift
//  DroidFinder
//
//  Created by Yoshihiro Tanaka on 2017/12/09.
//

import Foundation

class File {
    internal let filetype: FileType
    internal let filename: String
    internal let hasPermission: Bool
    
    init (filetype: FileType, filename: String, hasPermission: Bool) {
        self.filetype = filetype
        self.filename = filename
        self.hasPermission = hasPermission
    }
}
