import Cocoa

extension AppDelegate: NSApplicationDelegate {
    func applicationDidBecomeActive(_ notification: Notification) {
        Task {
            let isRunning = await mpvLauncher.isRunning
            if !panel.isVisible && !isRunning {
                displayOpenPanel()
            }
        }
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        Task {
            let isRunning = await mpvLauncher.isRunning
            if !flag && !panel.isVisible && !isRunning {
                displayOpenPanel()
            }
        }
        return true
    }

    func application(_ application: NSApplication, open urls: [URL]) {
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
        Task {
            await mpvLauncher.stop()
        }
    }
}
