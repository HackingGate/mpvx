import Cocoa
import FirebaseCore
import FirebaseAnalytics

extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        FirebaseApp.configure()
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        Analytics.logEvent("app_became_active", parameters: nil)
        Task {
            let isRunning = await mpvLauncher.isRunning
            if !panel.isVisible && !isRunning {
                displayOpenPanel()
            }
        }
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        Analytics.logEvent("app_reopened", parameters: [
            "has_visible_windows": flag
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
            Analytics.logEvent("open_url", parameters: [
                "url_path": url.path
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
        Analytics.logEvent("app_terminated", parameters: nil)
        Task {
            await mpvLauncher.stop()
        }
    }
}
