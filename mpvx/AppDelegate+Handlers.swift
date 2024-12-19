import Cocoa

extension AppDelegate {
    internal func handleCompletion(_ response: NSApplication.ModalResponse, urls: [URL]) {
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

    internal func handleLaunchResult(result: CompletionType, urls: [URL]) {
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
}
