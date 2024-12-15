import Cocoa

enum CompletionType {
    case terminated(status: Int32)
    case failure(error: String)
    case notFound
}

@MainActor
class MpvLauncher {
    private var mpvTask: Process?
    var mpvPathProvider: MpvPathProviding
    
    init(mpvPathProvider: MpvPathProviding = MpvPathProvider()) {
        self.mpvPathProvider = mpvPathProvider
    }
    
    private var isLaunching = false
    
    var isRunning: Bool {
        guard let mpvTask else { return isLaunching }
        return isLaunching || mpvTask.isRunning
    }

    func launch(with urls: [URL], completion: @escaping @Sendable (CompletionType) -> Void) {
        isLaunching = true
        for url in urls {
            NSDocumentController.shared.noteNewRecentDocumentURL(url)
        }
        let args = urls.map { $0.absoluteString }
        launchMpv(args, completion: completion)
    }

    private func launchMpv(_ args: [String], completion: @escaping @Sendable (CompletionType) -> Void) {
        if let mpvInstallPath = mpvPathProvider.mpvInstallPath() {
            let task = Process()
            task.launchPath = mpvInstallPath
            let mpvxArgs = ["--screenshot-directory=\(NSHomeDirectory())/Desktop/"]
            task.arguments = mpvxArgs + args
            let pipe = Pipe()
            task.standardOutput = pipe
            task.terminationHandler = { [weak self] _ in
                let terminationStatus = task.terminationStatus
                print(terminationStatus)
                print(task.terminationReason)
                Task { @MainActor [weak self] in
                    self?.isLaunching = false
                    completion(.terminated(status: terminationStatus))
                }
            }
            do {
                try task.run()
                mpvTask = task
            } catch {
                mpvTask = nil
                isLaunching = false
                completion(.failure(error: error.localizedDescription))
                let alert = NSAlert()
                alert.messageText = "Failed to launch mpv"
                alert.informativeText = error.localizedDescription
                alert.addButton(withTitle: "OK")
                alert.runModal()
            }
        } else {
            isLaunching = false
            completion(.notFound)
            let alert = NSAlert()
            alert.messageText = "mpv not found"
            alert.informativeText = "Please install mpv and relaunch."
            alert.addButton(withTitle: "Open Help")
            alert.addButton(withTitle: "Cancel")
            alert.buttons[0].setAccessibilityIdentifier("Open Help")
            alert.buttons[1].setAccessibilityIdentifier("Cancel")
            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                NSWorkspace.shared.open(helpURL)
            }
        }
    }
}
