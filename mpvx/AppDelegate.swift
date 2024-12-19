import Cocoa

@main
@MainActor
class AppDelegate: NSObject {
    private lazy var mpvLauncher: MpvLauncher = {
        return createMpvLauncher()
    }()
    internal var panel = NSOpenPanel()
    private var urlsToOpen: [URL] = []

    private func createMpvLauncher() -> MpvLauncher {
        var mpvPathProvider: MpvPathProviding = MpvPathProvider()
        for arg in CommandLine.arguments {
            if arg.hasPrefix("\(argMpvBinaryPath)=") {
                let path = String(arg.dropFirst("\(argMpvBinaryPath)=".count))
                mpvPathProvider = MpvPathProvider(customMpvPath: path)
                break
            }
        }
        return MpvLauncher(mpvPathProvider: mpvPathProvider)
    }

    internal func displayOpenPanel() {
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = true
        panel.begin { [weak self] response in
            if let panel = self?.panel {
                self?.panelCompletionHandler(response, urls: panel.urls)
            }
        }
    }

    internal func panelCompletionHandler(_ response: NSApplication.ModalResponse, urls: [URL]) {
        if response == .OK {
            Task(priority: .userInitiated) {
                await mpvLauncher.launch(with: urls) { result in
                    DispatchQueue.main.async {
                        self.handleLaunchResult(result: result, urls: urls)
                    }
                }
            }
        }
    }

    private func handleLaunchResult(result: CompletionType, urls: [URL]) {
        switch result {
        case .terminated(_):
            for url in urls {
                NSDocumentController.shared.noteNewRecentDocumentURL(url)
            }
        case .failure(let error):
            let alert = NSAlert()
            alert.messageText = "Failed to launch mpv"
            alert.informativeText = error.localizedDescription
            alert.addButton(withTitle: "OK")
            alert.runModal()
        case .mpvPathNotFound:
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
        displayOpenPanel()
    }

    @IBAction func showMpvxRepo(_ sender: Any) {
        NSWorkspace.shared.open(helpURL)
    }

    @IBAction func showMpvMannual(_ sender: Any) {
        NSWorkspace.shared.open(mpvMannualURL)
    }
}

extension AppDelegate: NSApplicationDelegate {
    func applicationDidBecomeActive(_ notification: Notification) {
        Task {
            let isRunning = await mpvLauncher.isRunning
            if !panel.isVisible && !isRunning {
                displayOpenPanel()
            }
        }
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        Task {
            let isRunning = await mpvLauncher.isRunning
            if !flag && !panel.isVisible && !isRunning {
                displayOpenPanel()
            }
        }

        return true
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        Task(priority: .userInitiated) {
            await mpvLauncher.launch(with: urls) { result in
                DispatchQueue.main.async {
                    self.handleLaunchResult(result: result, urls: urls)
                }
            }
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        Task {
            await mpvLauncher.stop()
        }
    }
}
