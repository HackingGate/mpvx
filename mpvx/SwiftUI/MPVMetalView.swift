import SwiftUI

struct MPVMetalView: NSViewControllerRepresentable {
    typealias NSViewControllerType = MPVMetalViewController

    @Binding var playUrl: URL?

    func makeNSViewController(context: Context) -> MPVMetalViewController {
        let controller = MPVMetalViewController()
        if let url = playUrl {
            controller.playUrl = url
        }
        return controller
    }

    func updateNSViewController(_ nsViewController: MPVMetalViewController, context: Context) {
        if let url = playUrl {
            nsViewController.loadFile(url)
        }
    }
}
