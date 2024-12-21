import Cocoa

extension AppDelegate {
    internal func handlePanelCompletion(_ response: NSApplication.ModalResponse, urls: [URL]) {
        if response == .OK {
            Task(priority: .userInitiated) {
                do {
                    try await mpvLauncher.launch(with: urls) { result in
                        DispatchQueue.main.async {
                            self.handleMpvLaunchResult(result: result, urls: urls)
                        }
                    }
                } catch {
                    self.handleMpvLaunchError(error: error)
                }
            }
        }
    }

    internal func handleMpvLaunchError(error: Error) {
        if let error = error as? MpvLauncherError {
            showAlert(for: error)
        } else {
            showGenericAlert(message: "Failed to launch mpv", description: error.localizedDescription)
        }
    }

    /// Displays an alert for `MpvLauncherError` cases.
    private func showAlert(for error: MpvLauncherError) {
        let alert = NSAlert()
        alert.messageText = error.localizedDescription
        if let recoverySuggestion = error.recoverySuggestion {
            alert.informativeText = recoverySuggestion
        }

        switch error {
        case .mpvPathNotFound:
            alert.addButton(withTitle: "Open Help")
            alert.addButton(withTitle: "Cancel")
            alert.buttons[0].setAccessibilityIdentifier("Open Help")
            alert.buttons[1].setAccessibilityIdentifier("Cancel")
            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                // Open help URL
                NSWorkspace.shared.open(helpURL)
            }
        case .mpvAlreadyRunning:
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }

    /// Displays a generic alert for non-`MpvLauncherError` errors.
    private func showGenericAlert(message: String, description: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = description
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    internal func handleMpvLaunchResult(result: CompletionType, urls: [URL]) {
        switch result {
        case .terminated(_):
            for url in urls {
                NSDocumentController.shared.noteNewRecentDocumentURL(url)
            }
        }
    }
}
