import Cocoa
import SwiftUI

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

    internal func launchPlayerWindow(with url: URL) {
        let viewModel = MPVXViewModel()
        viewModel.playUrl = url

        let contentView = MPVXPlayerView(viewModel: viewModel)

        let playerWindow = NSWindow(
            contentRect: NSRect(x: 100, y: 100, width: 800, height: 600),
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        playerWindow.title = url.lastPathComponent.truncatedFilename(to: 100)
        playerWindow.contentView = NSHostingView(rootView: contentView)
        playerWindow.makeKeyAndOrderFront(nil)

        // Retain the window to avoid it being deallocated
        self.playerWindow = playerWindow
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
