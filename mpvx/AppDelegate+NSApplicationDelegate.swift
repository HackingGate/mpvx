import Cocoa
import FirebaseCore

extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        #if DEBUG
        print("Skipping Firebase configuration in DEBUG mode")
        #else
        FirebaseApp.configure()
        #endif
        AnalyticsLogger.logEvent(.appOpen)
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        AnalyticsLogger.logEvent(.appBecameActive)
        displayOpenPanel()
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        AnalyticsLogger.logEvent(.appReopened, parameters: [
            .hasVisibleWindows: flag
        ])
        displayOpenPanel()
        return true
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        if let firstUrl = urls.first {
            DispatchQueue.main.async {
                self.launchPlayerWindow(with: firstUrl)
            }
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        AnalyticsLogger.logEvent(.appTerminated)
    }
}
