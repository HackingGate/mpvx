import Cocoa

extension AppDelegate {
    internal func displayOpenPanel() {
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
        displayOpenPanel()
    }

    @IBAction func showMpvxRepo(_ sender: Any) {
        NSWorkspace.shared.open(helpURL)
    }

    @IBAction func showMpvMannual(_ sender: Any) {
        NSWorkspace.shared.open(mpvMannualURL)
    }
}
