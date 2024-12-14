import Cocoa

@main
@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    var isOpenFromURLs = false
    var mpvPathProvider: MpvPathProviding = MpvPathProvider()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        for arg in CommandLine.arguments {
            if arg.hasPrefix("\(argMpvBinaryPath)=") {
                let path = String(arg.dropFirst("\(argMpvBinaryPath)=".count))
                mpvPathProvider = MpvPathProvider(customMpvPath: path)
                break
            }
        }
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if (!flag) {
            displayOpenPannel()
        }
        return true
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        isOpenFromURLs = true
        handleOpen(urls)
    }

    func displayOpenPannel() {
        let panel = NSOpenPanel()
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = true
        panel.begin() {
            if $0 == .OK {
                self.handleOpen(panel.urls)
            }
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
        if let mpvInstallPath = mpvPathProvider.mpvInstallPath() {
            let task = Process()
            task.launchPath = mpvInstallPath
            let mpvxArgs = ["--screenshot-directory=\(NSHomeDirectory())/Desktop/"]
            task.arguments = mpvxArgs + args
            let pipe = Pipe()
            task.standardOutput = pipe
            task.launch()
        } else {
            let alert = NSAlert()
            alert.messageText = "mpv not found"
            alert.informativeText = "Please install mpv and relaunch."
            alert.addButton(withTitle: "Open Help")
            alert.addButton(withTitle: "Cancel")
            alert.buttons[0].setAccessibilityIdentifier("Open Help")
            alert.buttons[1].setAccessibilityIdentifier("Cancel")
            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                NSWorkspace.shared.open(helpURL)
            }
        }
    }

    @IBAction func handleMenuOpen(_ sender: Any) {
        displayOpenPannel()
    }

    @IBAction func showRepo(_ sender: Any) {
        NSWorkspace.shared.open(helpURL)
    }

    @IBAction func showMpvMannual(_ sender: Any) {
        NSWorkspace.shared.open(mpvMannualURL)
    }
}

