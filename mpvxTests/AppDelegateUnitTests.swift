import XCTest
@testable import mpvx

@MainActor
class AppDelegateUnitTests: XCTestCase {
    var appDelegate: AppDelegate!

    override func setUpWithError() throws {
        try super.setUpWithError()
        appDelegate = AppDelegate()
    }

    override func tearDownWithError() throws {
        appDelegate = nil
        try super.tearDownWithError()
    }

    // MARK: - AppDelegate+Actions tests
    func testHandleMenuOpen() {
        appDelegate.handleMenuOpen(self)
        sleep(5)
        XCTAssertTrue(appDelegate.panel.isVisible)
    }

    func testShowRepo() {
        appDelegate.showMpvxRepo(self)
    }

    func testShowMpvMannual() {
        appDelegate.showMpvMannual(self)
    }

    // MARK: - AppDelegate+Handlers tests
    func testPanelCompletionHandlerWithOK() {
        appDelegate.handlePanelCompletion(.OK, urls: [bigBuckBunnyURL])
        sleep(5)
        XCTAssertFalse(appDelegate.panel.isVisible)
    }

    func testPanelCompletionHandlerWithCancel() {
        appDelegate.handlePanelCompletion(.cancel, urls: [])
        XCTAssertFalse(appDelegate.panel.isVisible)
    }

    // MARK: - AppDelegate+NSApplicationDelegate tests
    func testApplicationDidBecomeActive() {
        appDelegate.applicationDidBecomeActive(Notification(name: Notification.Name("")))
        let expectation = self.expectation(description: "Check panel visibility")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertNotNil(self.appDelegate)
            XCTAssertTrue(self.appDelegate.panel.isVisible)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func testApplicationShouldHandleReopen() {
        let result = appDelegate.applicationShouldHandleReopen(NSApplication.shared, hasVisibleWindows: false)
        XCTAssertTrue(result)
    }

    func testApplicationOpenSampleVideoURL() {
        appDelegate.application(NSApplication.shared, open: [bigBuckBunnyURL])
        sleep(5)
        XCTAssertFalse(appDelegate.panel.isVisible)
    }
}
