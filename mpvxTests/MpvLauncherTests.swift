import XCTest
@testable import mpvx

struct MockMpvPathProvider: MpvPathProviding {
    var customMpvPath: String?

    func mpvExecutableURL() -> URL? {
        if let customMpvPath = customMpvPath {
            return URL(fileURLWithPath: customMpvPath)
        }
        return nil
    }
}

@MainActor
class MpvLauncherTests: XCTestCase {
    func testLaunchSuccessAndTermination() async {
        let launcher = MpvLauncher()
        let expectation = self.expectation(description: "Launch should succeed")
        Task {
            do {
                try await launcher.launch(with: [bigBuckBunnyURL]) { result in
                    if case .terminated(let status) = result {
                        XCTAssertEqual(status, 4)
                        expectation.fulfill()
                    }
                }
            }
            sleep(5)
            await launcher.stop()
        }
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testLaunchSuccessAndAnotherLaunchFailure() async {
        let launcher = MpvLauncher()
        let expectation = self.expectation(description: "Launch should succeed")
        Task {
            do {
                try await launcher.launch(with: [bigBuckBunnyURL]) { result in
                    if case .terminated(let status) = result {
                        XCTAssertEqual(status, 4)
                    }
                }
                sleep(5)
                try await launcher.launch(with: [bigBuckBunnyURL]) { result in
                    XCTFail("The second launch should fail")
                }
            } catch {
                XCTAssertEqual(error as! MpvLauncherError, MpvLauncherError.mpvAlreadyRunning)
                expectation.fulfill()
            }
        }
        await fulfillment(of: [expectation], timeout: 10.0)
    }

    func testLaunchSuccessAndAnotherLaunchSuccessAndTermination() async {
        let launcher = MpvLauncher()
        let expectation = self.expectation(description: "Launch should succeed")
        Task {
            do {
                try await launcher.launch(with: [bigBuckBunnyURL]) { result in
                    if case .terminated(let status) = result {
                        XCTAssertEqual(status, 4)
                    }
                }
                sleep(5)
                await launcher.stop()
                try await launcher.launch(with: [bigBuckBunnyURL]) { result in
                    if case .terminated(let status) = result {
                        XCTAssertEqual(status, 4)
                        expectation.fulfill()
                    }
                }
                sleep(5)
                await launcher.stop()
            } catch {
                XCTFail("The second launch should succeed")
            }
        }
        await fulfillment(of: [expectation], timeout: 15.0)
    }

    func testLaunchFailedNonExistingPath() async {
        let nonExistingPath = "/non_exist_folder/mpv"
        let mockPathProvider = MockMpvPathProvider(customMpvPath: nonExistingPath)
        let launcher = MpvLauncher(mpvPathProvider: mockPathProvider)
        let expectation = self.expectation(description: "Launch should fail")
        Task {
            do {
                try await launcher.launch(with: [bigBuckBunnyURL]) { result in
                    XCTFail("The launch should fail")
                }
            } catch {
                XCTAssertEqual(error.localizedDescription, "The file “mpv” doesn’t exist.")
                expectation.fulfill()
            }
        }
        await fulfillment(of: [expectation], timeout: 5.0)
    }

    func testLaunchFailedWithNoPath() async {
        let mockPathProvider = MockMpvPathProvider(customMpvPath: nil)
        let launcher = MpvLauncher(mpvPathProvider: mockPathProvider)
        let expectation = self.expectation(description: "Launch should fail")
        Task {
            do {
                try await launcher.launch(with: [bigBuckBunnyURL]) { result in
                    XCTFail("The launch should fail")
                }
            } catch {
                XCTAssertEqual(error as! MpvLauncherError, MpvLauncherError.mpvPathNotFound)
                expectation.fulfill()
            }
        }
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
