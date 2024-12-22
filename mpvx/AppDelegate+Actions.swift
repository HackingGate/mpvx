import Cocoa

extension AppDelegate {
    internal func displayOpenPanel() {
        AnalyticsLogger.logEvent(.displayOpenPanel)
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = true
        panel.begin { [weak self] response in
            if let panel = self?.panel {
                self?.handlePanelCompletion(response, urls: panel.urls)
            }
        }
    }

    @IBAction func handleMenuOpen(_ sender: Any) {
        AnalyticsLogger.logEvent(.menuOpenClicked, parameters: [
            .sender: String(describing: sender)
        ])
        displayOpenPanel()
    }

    @IBAction func showMpvxRepo(_ sender: Any) {
        AnalyticsLogger.logEvent(.mpvxRepoOpened, parameters: [
            .url: helpURL.absoluteString
        ])
        NSWorkspace.shared.open(helpURL)
    }

    @IBAction func showMpvMannual(_ sender: Any) {
        AnalyticsLogger.logEvent(.mpvManualOpened, parameters: [
            .url: mpvMannualURL.absoluteString
        ])
        NSWorkspace.shared.open(mpvMannualURL)
    }
}
