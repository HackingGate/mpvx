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

    internal func displayOpenPannel() {
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = true
        panel.begin { [weak self] response in
            if let panel = self?.panel {
                self?.pannelCompletionHandler(response, urls: panel.urls)
            }
        }
    }

    internal func pannelCompletionHandler(_ response: NSApplication.ModalResponse, urls: [URL]) {
        if response == .OK {
            mpvLauncher.launch(with: urls, completion: AppDelegate.commonCompletionHandler)
        }
    }

    static func commonCompletionHandler(result: CompletionType) {
        switch result {
        case .terminated(let status):
            print("Mpv terminated with status: \(status)")
        case .failure(let error):
            print("Mpv launch failed with error: \(error)")
        case .notFound:
            print("Mpv not found. Please ensure it is installed.")
        }
    }

    @IBAction func handleMenuOpen(_ sender: Any) {
        displayOpenPannel()
    }

    @IBAction func showRepo(_ sender: Any) {
        NSWorkspace.shared.open(helpURL)
    }

    @IBAction func showMpvMannual(_ sender: Any) {
        NSWorkspace.shared.open(mpvMannualURL)
    }
}

extension AppDelegate: NSApplicationDelegate {
    func applicationDidBecomeActive(_ notification: Notification) {
        if !panel.isVisible && !mpvLauncher.isRunning, let _ = mpvLauncher.mpvPathProvider.mpvInstallPath() {
            displayOpenPannel()
        }
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag && !panel.isVisible && !mpvLauncher.isRunning, let _ = mpvLauncher.mpvPathProvider.mpvInstallPath() {
            displayOpenPannel()
        }
        return true
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        mpvLauncher.launch(with: urls, completion: AppDelegate.commonCompletionHandler)
    }

    func applicationWillTerminate(_ notification: Notification) {
        mpvLauncher.stop()
    }
}
