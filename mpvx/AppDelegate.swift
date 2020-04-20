//
//  AppDelegate.swift
//  mpvx
//
//  Created by HG on 2020/04/20.
//  Copyright © 2020 HG. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        openFile(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func openFile(_ sender: AnyObject?) {
        let panel = NSOpenPanel()
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = true
        if panel.runModal() == .OK {
            for url in panel.urls {
                NSDocumentController.shared.noteNewRecentDocumentURL(url)
                let task = Process()
                task.launchPath = "/usr/local/bin/mpv"
                task.arguments = [url.absoluteString]
                let pipe = Pipe()
                task.standardOutput = pipe
                task.launch()
            }
        }
    }
}

