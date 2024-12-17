import Cocoa

enum CompletionType {
    case terminated(status: Int32)
    case failure(error: any Error)
    case notFound
}

@MainActor
class MpvLauncher {
    private var mpvTask: Process?
    var mpvPathProvider: any MpvPathProviding

    init(mpvPathProvider: any MpvPathProviding = MpvPathProvider()) {
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

    func stop() {
        guard let task = mpvTask, task.isRunning else {
            print("No running task to terminate.")
            return
        }
        task.terminate()
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
                completion(.failure(error: error))
            }
        } else {
            isLaunching = false
            completion(.notFound)
        }
    }
}
