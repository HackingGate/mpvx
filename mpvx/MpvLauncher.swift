import Cocoa

enum CompletionType {
    case terminated(status: Int32)
    case failure(error: any Error)
    case mpvPathNotFound
}

enum MpvError: Error {
    case mpvAlreadyRunning
}

extension MpvError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .mpvAlreadyRunning:
            return NSLocalizedString("MPV is already running.", comment: "Error when MPV is launched more than once.")
        }
    }

    var failureReason: String? {
        switch self {
        case .mpvAlreadyRunning:
            return NSLocalizedString("Another instance of MPV is still active.", comment: "Explanation why MPV can't run.")
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .mpvAlreadyRunning:
            return NSLocalizedString("Please close the existing MPV instance and try again.", comment: "Suggested action for user.")
        }
    }

    var helpAnchor: String? {
        switch self {
        case .mpvAlreadyRunning:
            return NSLocalizedString("mpvAlreadyRunningHelp", comment: "Help anchor for more information.")
        }
    }
}

actor MpvLauncher {
    private lazy var mpvTask: Process = {
        return Process()
    }()
    private var mpvPathProvider: any MpvPathProviding

    init(mpvPathProvider: any MpvPathProviding = MpvPathProvider()) {
        self.mpvPathProvider = mpvPathProvider
    }

    private var isLaunching = false

    private func setLaunchingState(to state: Bool) {
        isLaunching = state
    }

    var isRunning: Bool {
        return isLaunching || mpvTask.isRunning
    }

    func launch(
        with urls: [URL],
        completion: @Sendable @escaping (CompletionType) -> Void
    ) {
        isLaunching = true
        let args = urls.map { $0.absoluteString }
        launchMpv(args, completion: completion)
    }

    func stop() {
        mpvTask.terminate()
        mpvTask.waitUntilExit()
        mpvTask = Process()
    }

    private func launchMpv(
        _ args: [String],
        completion: @escaping @Sendable (CompletionType) -> Void
    ) {
        if let mpvExecutableURL = mpvPathProvider.mpvExecutableURL() {
            if mpvTask.isRunning {
                completion(.failure(error: MpvError.mpvAlreadyRunning))
                return
            }
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
                    await self?.setLaunchingState(to: false)
                    completion(.terminated(status: terminationStatus))
                }
            }
            do {
                try mpvTask.run()
            } catch {
                isLaunching = false
                completion(.failure(error: error))
            }
        } else {
            isLaunching = false
            completion(.mpvPathNotFound)
        }
    }
}
