import Cocoa
import FirebaseCore

extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        #if RELEASE
        FirebaseApp.configure()
        #endif
        AnalyticsLogger.logEvent(.appOpen)
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        AnalyticsLogger.logEvent(.appBecameActive)
        Task {
            let isRunning = await mpvLauncher.isRunning
            if !panel.isVisible && !isRunning {
                displayOpenPanel()
            }
        }
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        AnalyticsLogger.logEvent(.appReopened, parameters: [
            .hasVisibleWindows: flag
        ])
        Task {
            let isRunning = await mpvLauncher.isRunning
            if !flag && !panel.isVisible && !isRunning {
                displayOpenPanel()
            }
        }
        return true
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        for url in urls {
            AnalyticsLogger.logEvent(.openUrl, parameters: [
                .urlPath: url.lastPathComponent.truncatedFilename(to: 100)
            ])
        }
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

    func applicationWillTerminate(_ notification: Notification) {
        AnalyticsLogger.logEvent(.appTerminated)
        Task {
            await mpvLauncher.stop()
        }
    }
}
