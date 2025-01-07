import AppKit
import Combine

class MPVXViewModel: ObservableObject {
    @Published var playUrl: URL?
    @Published var isPlaying: Bool = false

    func selectVideo() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = false

        if panel.runModal() == .OK, let url = panel.url {
            playUrl = url
        }
    }

    func togglePlayPause() {
        isPlaying.toggle()
        // Call playback functions in the view controller if needed
    }
}
