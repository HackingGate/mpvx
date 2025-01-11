import SwiftUI

struct MPVXPlayerView: View {
    @ObservedObject var viewModel: MPVXViewModel

    var body: some View {
        VStack {
            MPVXView(playUrl: $viewModel.playUrl)
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
