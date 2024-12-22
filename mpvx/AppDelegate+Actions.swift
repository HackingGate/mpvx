import Cocoa
import FirebaseAnalytics

extension AppDelegate {
    internal func displayOpenPanel() {
        Analytics.logEvent("display_open_panel", parameters: nil)
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
        Analytics.logEvent("menu_open_clicked", parameters: [
            "sender": String(describing: sender)
        ])
        displayOpenPanel()
    }

    @IBAction func showMpvxRepo(_ sender: Any) {
        Analytics.logEvent("mpvx_repo_opened", parameters: [
            "url": helpURL.absoluteString
        ])
        NSWorkspace.shared.open(helpURL)
    }

    @IBAction func showMpvMannual(_ sender: Any) {
        Analytics.logEvent("mpv_manual_opened", parameters: [
            "url": mpvMannualURL.absoluteString
        ])
        NSWorkspace.shared.open(mpvMannualURL)
    }
}
