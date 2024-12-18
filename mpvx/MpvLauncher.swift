import Cocoa

enum CompletionType {
    case terminated(status: Int32)
    case failure(error: any Error)
    case notFound
}

actor MpvLauncher {
    private var mpvTask: Process?
    private var mpvPathProvider: any MpvPathProviding

    init(mpvPathProvider: any MpvPathProviding = MpvPathProvider()) {
        self.mpvPathProvider = mpvPathProvider
    }

    private var isLaunching = false

    private func setLaunchingState(to state: Bool) {
        isLaunching = state
    }

    var isRunning: Bool {
        guard let mpvTask else { return isLaunching }
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
        guard let task = mpvTask, task.isRunning else {
            print("No running task to terminate.")
            return
        }
        task.terminate()
    }

    private func launchMpv(
        _ args: [String],
        completion: @escaping @Sendable (CompletionType) -> Void
    ) {
        if let mpvInstallPath = mpvPathProvider.mpvInstallPath() {
            let task = Process()
            task.launchPath = mpvInstallPath
            let mpvxArgs = ["--screenshot-directory=\(NSHomeDirectory())/Desktop/"]
            task.arguments = mpvxArgs + args
            let pipe = Pipe()
            task.standardOutput = pipe
            task.terminationHandler = { task in
                let terminationStatus = task.terminationStatus
                print(terminationStatus)
                print(task.terminationReason)
                Task { [weak self] in
                    guard let self = self else { return }
                    await self.setLaunchingState(to: false)
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
