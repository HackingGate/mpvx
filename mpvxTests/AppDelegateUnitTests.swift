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
    
    func testApplicationDidBecomeActive() {
        appDelegate.applicationDidBecomeActive(Notification(name: Notification.Name("")))
        XCTAssertTrue(appDelegate.panel.isVisible)
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
    
    func testPannelCompletionHandlerWithOK() {
        appDelegate.pannelCompletionHandler(.OK, urls: [bigBuckBunnyURL])
        sleep(5)
        XCTAssertFalse(appDelegate.panel.isVisible)
    }
    
    func testPannelCompletionHandlerWithCancel() {
        appDelegate.pannelCompletionHandler(.cancel, urls: [])
        XCTAssertFalse(appDelegate.panel.isVisible)
    }
}
