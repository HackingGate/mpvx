import Cocoa

@main
@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    internal var isOpenFromURLs = false
    private var mpvPathProvider: MpvPathProviding = MpvPathProvider()
    private lazy var mpvLauncher: MpvLauncher = {
        return createMpvLauncher()
    }()
    internal var panel = NSOpenPanel()
    internal var isPanelOpen = false
    private var urlsToOpen: [URL] = []

    private func createMpvLauncher() -> MpvLauncher {
        for arg in CommandLine.arguments {
            if arg.hasPrefix("\(argMpvBinaryPath)=") {
                let path = String(arg.dropFirst("\(argMpvBinaryPath)=".count))
                mpvPathProvider = MpvPathProvider(customMpvPath: path)
                break
            }
        }
        return MpvLauncher(mpvPathProvider: mpvPathProvider)
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        if !isPanelOpen && !mpvLauncher.isRunning {
            displayOpenPannel()
        }
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if (!flag && !isPanelOpen && !mpvLauncher.isRunning) {
            displayOpenPannel()
        }
        return true
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        isOpenFromURLs = true
        mpvLauncher.launch(with: urls, completion: AppDelegate.commonCompletionHandler)
    }

    func displayOpenPannel() {
        isPanelOpen = true
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = true
        panel.begin(completionHandler: pannelCompletionHandler)
    }

    func pannelCompletionHandler(_ response: NSApplication.ModalResponse) {
        if response == .OK {
            mpvLauncher.launch(with: panel.urls, completion: AppDelegate.commonCompletionHandler)
        }
        isPanelOpen = false
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
