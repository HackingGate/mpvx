import XCTest
@testable import mpvx

@MainActor
class MpvLauncherTests: XCTestCase {
    func testLaunchSuccess() async {
        let launcher = MpvLauncher()
        let expectation = self.expectation(description: "Launch should succeed")
        Task {
            launcher.launch(with: [bigBuckBunnyURL]) { result in
                if case .terminated(let status) = result {
                    XCTAssertEqual(status, 4)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected successful termination")
                }
            }
            sleep(5)
            launcher.stop()
        }
        await fulfillment(of: [expectation])
    }
}
