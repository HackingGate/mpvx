import Foundation
import SwiftUI

struct MPVPlayerView: NSViewControllerRepresentable {
    @ObservedObject var coordinator: Coordinator

    func makeNSViewController(context: Context) -> some NSViewController {
        let mpv =  MPVViewController()
        mpv.playDelegate = coordinator
        mpv.playUrl = coordinator.playUrl

        context.coordinator.player = mpv
        return mpv
    }

    func updateNSViewController(_ nsViewController: NSViewControllerType, context: Context) {

    }

    public func makeCoordinator() -> Coordinator {
        coordinator
    }

    func play(_ url: URL) -> Self {
        coordinator.playUrl = url
        return self
    }

    func onPropertyChange(_ handler: @escaping (MPVViewController, String, Any?) -> Void) -> Self {
        coordinator.onPropertyChange = handler
        return self
    }

    @MainActor
    public final class Coordinator: MPVPlayerDelegate, ObservableObject {
        weak var player: MPVViewController?

        var playUrl: URL?
        var onPropertyChange: ((MPVViewController, String, Any?) -> Void)?

        @Published var pause: Bool = false {
            didSet {
                if pause {
                    self.player?.pause()
                } else {
                    self.player?.play()
                }
            }
        }

        @Published var hdrEnabled: Bool = false {
            didSet {
                self.player?.hdrEnabled = hdrEnabled
            }
        }

        @Published var hdrAvailable: Bool = false
        @Published var edrRange: String = "1.0"

        func play(_ url: URL) {
            player?.loadFile(url)
        }

        func propertyChange(mpv: OpaquePointer, propertyName: String, data: Any?) {
            guard let player else { return }

            self.onPropertyChange?(player, propertyName, data)
        }
    }
}
