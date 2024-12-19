import Cocoa

@main
@MainActor
class AppDelegate: NSObject {
    private var urlsToOpen: [URL] = []
    internal var panel = NSOpenPanel()
    internal lazy var mpvLauncher: MpvLauncher = {
        return createMpvLauncher()
    }()

    private func createMpvLauncher() -> MpvLauncher {
        var mpvPathProvider: MpvPathProviding = MpvPathProvider()
        for arg in CommandLine.arguments {
            if arg.hasPrefix("\(argMpvBinaryPath)=") {
                let path = String(arg.dropFirst("\(argMpvBinaryPath)=".count))
                mpvPathProvider = MpvPathProvider(customMpvPath: path)
                break
            }
        }
        return MpvLauncher(mpvPathProvider: mpvPathProvider)
    }
}
