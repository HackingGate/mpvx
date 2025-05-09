import Cocoa

@main
@MainActor
class AppDelegate: NSObject {
    private var urlsToOpen: [URL] = []
    internal var panel = NSOpenPanel()
    var playerWindow: NSWindow?
}
