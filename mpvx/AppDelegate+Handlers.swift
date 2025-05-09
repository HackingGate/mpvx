import Cocoa

extension AppDelegate {
    internal func handlePanelCompletion(_ response: NSApplication.ModalResponse, urls: [URL]) {
        AnalyticsLogger.logEvent(.panelCompletion, parameters: [
            .response: response.rawValue,
            .urlCount: urls.count
        ])
        if response == .OK, let firstUrl = urls.first {
            DispatchQueue.main.async {
                self.launchPlayerWindow(with: firstUrl)
            }
        }
    }
}
