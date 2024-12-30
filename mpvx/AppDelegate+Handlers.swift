import Cocoa

extension AppDelegate {
    internal func handlePanelCompletion(_ response: NSApplication.ModalResponse, urls: [URL]) {
        AnalyticsLogger.logEvent(.panelCompletion, parameters: [
            .response: response.rawValue,
            .urlCount: urls.count
        ])
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
        AnalyticsLogger.logEvent(.mpvLaunchError, parameters: [
            .errorDescription: errorDescription
        ])
        if let error = error as? MpvLauncherError {
            showAlert(for: error)
        } else {
            showGenericAlert(message: "Failed to launch mpv", description: errorDescription)
        }
    }

    private func showAlert(for error: MpvLauncherError) {
        AnalyticsLogger.logEvent(.mpvLauncherError, parameters: [
            .errorType: String(describing: error)
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
            AnalyticsLogger.logEvent(.alertResponse, parameters: [
                .response: response.rawValue,
                .errorType: "mpvPathNotFound"
            ])
            if response == .alertFirstButtonReturn {
                NSWorkspace.shared.open(helpURL)
            }
        case .mpvAlreadyRunning:
            alert.addButton(withTitle: "OK")
            alert.runModal()
            AnalyticsLogger.logEvent(.alertResponse, parameters: [
                .response: "OK",
                .errorType: "mpvAlreadyRunning"
            ])
        }
    }

    private func showGenericAlert(message: String, description: String) {
        AnalyticsLogger.logEvent(.genericAlertShown, parameters: [
            .message: message,
            .description: description
        ])
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = description
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    internal func handleMpvLaunchResult(result: CompletionType, urls: [URL]) {
        AnalyticsLogger.logEvent(.mpvLaunchResult, parameters: [
            .result: String(describing: result),
            .urlCount: urls.count
        ])
        switch result {
        case .terminated:
            for url in urls {
                NSDocumentController.shared.noteNewRecentDocumentURL(url)
            }
        }
    }
}
