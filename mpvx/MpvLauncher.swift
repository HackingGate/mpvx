import Cocoa

enum CompletionType {
    case terminated(status: Int32)
}

actor MpvLauncher {
    private lazy var mpvTask: Process = {
        return Process()
    }()
    private var mpvPathProvider: any MpvPathProviding

    init(mpvPathProvider: any MpvPathProviding = MpvPathProvider()) {
        self.mpvPathProvider = mpvPathProvider
    }

    var isRunning: Bool {
        mpvTask.isRunning
    }

    func launch(
        with urls: [URL],
        completion: @Sendable @escaping (CompletionType) -> Void
    ) throws {
        guard let mpvExecutableURL = mpvPathProvider.mpvExecutableURL() else {
            throw MpvLauncherError.mpvPathNotFound
        }
        if mpvTask.isRunning {
            throw MpvLauncherError.mpvAlreadyRunning
        }
        let args = urls.map { $0.absoluteString }
        try launchMpv(mpvExecutableURL, args, completion: completion)
    }

    func stop() {
        if mpvTask.isRunning {
            mpvTask.terminate()
            mpvTask.waitUntilExit()
        }
        mpvTask = Process()
    }

    private func launchMpv(
        _ mpvExecutableURL: URL,
        _ args: [String],
        completion: @escaping @Sendable (CompletionType) -> Void
    ) throws {
        mpvTask.executableURL = mpvExecutableURL
        let mpvxArgs = ["--screenshot-directory=\(NSHomeDirectory())/Desktop/"]
        mpvTask.arguments = mpvxArgs + args
        let pipe = Pipe()
        mpvTask.standardOutput = pipe
        mpvTask.terminationHandler = { task in
            let terminationStatus = task.terminationStatus
            print(terminationStatus)
            print(task.terminationReason)
            Task { [weak self] in
                await self?.stop()
                completion(.terminated(status: terminationStatus))
            }
        }
        try mpvTask.run()
    }
}
