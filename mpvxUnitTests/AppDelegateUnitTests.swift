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

    func testApplicationWillFinishLaunching() {
        appDelegate.isOpenFromURLs = false
        appDelegate.applicationWillFinishLaunching(Notification(name: Notification.Name("TestNotification")))
    }

    func testApplicationShouldHandleReopen() {
        let result = appDelegate.applicationShouldHandleReopen(NSApplication.shared, hasVisibleWindows: false)
        XCTAssertTrue(result)
    }

    func testApplicationOpenSampleVideoURL() {
        appDelegate.application(NSApplication.shared, open: [bigBuckBunnyURL])
        XCTAssertTrue(appDelegate.isOpenFromURLs)
    }

    func testHandleOpenWithSampleVideo() {
        appDelegate.handleOpen([bigBuckBunnyURL])
    }

    func testLaunchMpv() {
        let expectation = XCTestExpectation(description: "Process launched")
        let args = [bigBuckBunnyURL.absoluteString]
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
