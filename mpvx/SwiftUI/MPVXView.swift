import SwiftUI

struct MPVXView: NSViewControllerRepresentable {
    typealias NSViewControllerType = MPVViewController

    @Binding var playUrl: URL?

    func makeNSViewController(context: Context) -> MPVViewController {
        let controller = MPVViewController()
        controller.playUrl = playUrl
        return controller
    }

    func updateNSViewController(_ nsViewController: MPVViewController, context: Context) {
        if let url = playUrl {
            nsViewController.loadFile(url)
        }
    }
}
