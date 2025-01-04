import SwiftUI

struct MPVPlayerView: View {
    @ObservedObject var viewModel: MPVViewModel

    init(viewModel: MPVViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            MPVMetalView(playUrl: $viewModel.playUrl)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            HStack {
                Button(viewModel.isPlaying ? "Pause" : "Play") {
                    viewModel.togglePlayPause()
                }
                .disabled(viewModel.playUrl == nil)
            }
            .padding()
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}
