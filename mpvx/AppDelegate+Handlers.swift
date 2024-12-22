import Cocoa
import FirebaseAnalytics

extension AppDelegate {
    internal func handlePanelCompletion(_ response: NSApplication.ModalResponse, urls: [URL]) {
        Analytics.logEvent("panel_completion", parameters: [
            "response": response.rawValue,
            "url_count": urls.count
        ])
        for url in urls {
            Analytics.logEvent("open_url", parameters: [
                "url_path": url.lastPathComponent.truncatedFilename(to: 100)
            ])
        }
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
        let errorDescription = error.localizedDescription
        Analytics.logEvent("mpv_launch_error", parameters: [
            "error_description": errorDescription
        ])
        if let error = error as? MpvLauncherError {
            showAlert(for: error)
        } else {
            showGenericAlert(message: "Failed to launch mpv", description: errorDescription)
        }
    }

    private func showAlert(for error: MpvLauncherError) {
        Analytics.logEvent("mpv_launcher_error", parameters: [
            "error_type": String(describing: error)
        ])
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
            Analytics.logEvent("alert_response", parameters: [
                "response": response.rawValue,
                "error_type": "mpvPathNotFound"
            ])
            if response == .alertFirstButtonReturn {
                NSWorkspace.shared.open(helpURL)
            }
        case .mpvAlreadyRunning:
            alert.addButton(withTitle: "OK")
            alert.runModal()
            Analytics.logEvent("alert_response", parameters: [
                "response": "OK",
                "error_type": "mpvAlreadyRunning"
            ])
        }
    }

    private func showGenericAlert(message: String, description: String) {
        Analytics.logEvent("generic_alert_shown", parameters: [
            "message": message,
            "description": description
        ])
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = description
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    internal func handleMpvLaunchResult(result: CompletionType, urls: [URL]) {
        Analytics.logEvent("mpv_launch_result", parameters: [
            "result": String(describing: result),
            "url_count": urls.count
        ])
        switch result {
        case .terminated(_):
            for url in urls {
                Analytics.logEvent("recent_document_added", parameters: [
                    "url_path": url.lastPathComponent.truncatedFilename(to: 100)
                ])
                NSDocumentController.shared.noteNewRecentDocumentURL(url)
            }
        }
    }
}
