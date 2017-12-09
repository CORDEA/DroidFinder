//
//  CommandUtils.swift
//  DroidFinder
//
//  Created by Yoshihiro Tanaka on 2016/04/28.
//

import Foundation

class CommandUtils {

    static internal func getHome() -> String? {
        let env: [String: String] = ProcessInfo.processInfo.environment
        return env["HOME"]
    }

    static internal func execCommand(_ command: [String]) -> NSString? {
        if let home = getHome() {
            let task = Process()
            let pipe = Pipe()
            task.launchPath = home + "/Library/Android/sdk/platform-tools/adb"
            task.arguments = command
            task.standardOutput = pipe
            task.launch()
            task.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        }
        return nil
    }
}
