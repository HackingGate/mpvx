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
    
    func testPanelCompletionHandlerWithOK() {
        appDelegate.panelCompletionHandler(.OK, urls: [bigBuckBunnyURL])
        sleep(5)
        XCTAssertFalse(appDelegate.panel.isVisible)
    }
    
    func testPanelCompletionHandlerWithCancel() {
        appDelegate.panelCompletionHandler(.cancel, urls: [])
        XCTAssertFalse(appDelegate.panel.isVisible)
    }
}
