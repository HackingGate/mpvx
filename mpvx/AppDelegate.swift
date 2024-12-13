import Cocoa

@main
@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {

    let helpURL = URL(string: "https://github.com/HackingGate/mpvx")!
    let mpvMannualURL = URL(string: "https://mpv.io/manual/stable/")!
    var isOpenFromURLs = false

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if !isOpenFromURLs {
            displayOpenPannel()
        }
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if (!flag) {
            displayOpenPannel()
        }
        return true
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        isOpenFromURLs = true
        handleOpen(urls)
    }

    func displayOpenPannel() {
        let panel = NSOpenPanel()
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = true
        panel.begin() {
            if $0 == .OK {
                self.handleOpen(panel.urls)
            }
        }
    }

    func handleOpen(_ urls: [URL]) {
        for url in urls {
            NSDocumentController.shared.noteNewRecentDocumentURL(url)
        }
        let args = urls.map( { ($0.absoluteString) } )
        launchMpv(args)
    }

    func launchMpv(_ args: [String]) {
        let task = Process()
        #if arch(arm64)
        task.launchPath = "/opt/homebrew/bin/mpv"
        #else
        task.launchPath = "/usr/local/bin/mpv"
        #endif
        let mpvxArgs = ["--screenshot-directory=\(NSHomeDirectory())/Desktop/"]
        task.arguments = mpvxArgs + args
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
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

