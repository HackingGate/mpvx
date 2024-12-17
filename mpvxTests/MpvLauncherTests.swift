import XCTest
@testable import mpvx

struct MockMpvPathProvider: MpvPathProviding {
    var customMpvPath: String?

    func mpvInstallPath() -> String? {
        return customMpvPath
    }
}

@MainActor
class MpvLauncherTests: XCTestCase {
    func testLaunchSuccessAndTerminated() async {
        let launcher = MpvLauncher()
        let expectation = self.expectation(description: "Launch should succeed")
        Task {
            launcher.launch(with: [bigBuckBunnyURL]) { result in
                if case .terminated(let status) = result {
                    XCTAssertEqual(status, 4)
                    expectation.fulfill()
                }
            }
            sleep(5)
            launcher.stop()
        }
        await fulfillment(of: [expectation])
    }

    func testLaunchFailedNonExistingPath() async {
        let nonExistingPath = "/non_exist_folder/mpv"
        let mockPathProvider = MockMpvPathProvider(customMpvPath: nonExistingPath)
        let launcher = MpvLauncher(mpvPathProvider: mockPathProvider)
        let expectation = self.expectation(description: "Launch should fail")
        Task {
            launcher.launch(with: [bigBuckBunnyURL]) { result in
                if case .failure(let error) = result {
                    XCTAssertEqual(error.localizedDescription, "The file “mpv” doesn’t exist.")
                    expectation.fulfill()
                }
            }
        }
        await fulfillment(of: [expectation])
    }

    func testLaunchFailedWithNoPath() async {
        let mockPathProvider = MockMpvPathProvider(customMpvPath: nil)
        let launcher = MpvLauncher(mpvPathProvider: mockPathProvider)
        let expectation = self.expectation(description: "Launch should fail")
        Task {
            launcher.launch(with: [bigBuckBunnyURL]) { result in
                if case .notFound = result {
                    expectation.fulfill()
                }
            }
        }
        await fulfillment(of: [expectation])
    }
}
