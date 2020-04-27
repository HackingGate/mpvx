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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        displayOpenPannel()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if (!flag) {
            displayOpenPannel()
        }
        return true
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        handleOpen(urls)
    }

    func displayOpenPannel() {
        let panel = NSOpenPanel()
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = true
        if panel.runModal() == .OK {
            handleOpen(panel.urls)
        }
    }

    func handleOpen(_ urls: [URL]) {
        for url in urls {
            NSDocumentController.shared.noteNewRecentDocumentURL(url)
        }
        let args = urls.map( { ($0.absoluteString) } )
        launchMpv(args)
    }

    func launchMpv(_ args: [String]) {
        let task = Process()
        task.launchPath = "/usr/local/bin/mpv"
        task.arguments = args
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
    }

    @IBAction func handleMenuOpen(_ sender: AnyObject?) {
        displayOpenPannel()
    }
}

