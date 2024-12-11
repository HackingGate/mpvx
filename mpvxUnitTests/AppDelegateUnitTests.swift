import XCTest
@testable import mpvx

@MainActor
class AppDelegateUnitTests: XCTestCase {

    var appDelegate: AppDelegate!

    override func setUpWithError() throws {
        appDelegate = AppDelegate()
    }

    override func tearDownWithError() throws {
        appDelegate = nil
    }

    func testApplicationDidFinishLaunching() {
        appDelegate.isOpenFromURLs = false
        appDelegate.applicationDidFinishLaunching(Notification(name: Notification.Name("TestNotification")))
    }

    func testApplicationShouldHandleReopen() {
        let result = appDelegate.applicationShouldHandleReopen(NSApplication.shared, hasVisibleWindows: false)
        XCTAssertTrue(result)
    }

    func testApplicationOpenSampleVideoURL() {
        let sampleVideoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        appDelegate.application(NSApplication.shared, open: [sampleVideoURL])
        XCTAssertTrue(appDelegate.isOpenFromURLs)
    }

    func testHandleOpenWithSampleVideo() {
        let sampleVideoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        appDelegate.handleOpen([sampleVideoURL])
    }

    func testLaunchMpv() {
        let expectation = XCTestExpectation(description: "Process launched")
        let args = ["https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"]
        appDelegate.launchMpv(args)
        expectation.fulfill()
        wait(for: [expectation], timeout: 1.0)
    }

    func testHandleMenuOpen() {
        appDelegate.handleMenuOpen(self)
    }

    func testShowRepo() {
        appDelegate.showRepo(self)
    }

    func testShowMpvMannual() {
        appDelegate.showMpvMannual(self)
    }
}
