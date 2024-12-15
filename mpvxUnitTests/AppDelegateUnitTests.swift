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
        XCTAssertTrue(appDelegate.isPanelOpen)
    }

    func testApplicationShouldHandleReopen() {
        let result = appDelegate.applicationShouldHandleReopen(NSApplication.shared, hasVisibleWindows: false)
        XCTAssertTrue(result)
    }

    func testApplicationOpenSampleVideoURL() {
        appDelegate.application(NSApplication.shared, open: [bigBuckBunnyURL])
        XCTAssertTrue(appDelegate.isOpenFromURLs)
    }

    func testHandleMenuOpen() {
        appDelegate.handleMenuOpen(self)
        XCTAssertTrue(appDelegate.isPanelOpen)
    }

    func testShowRepo() {
        appDelegate.showRepo(self)
    }

    func testShowMpvMannual() {
        appDelegate.showMpvMannual(self)
    }
    
    func testPannelCompletionHandlerWithOK() {
        appDelegate.isPanelOpen = true
        appDelegate.pannelCompletionHandler(.OK)
        XCTAssertFalse(appDelegate.isPanelOpen)
    }
    
    func testPannelCompletionHandlerWithCancel() {
        appDelegate.isPanelOpen = true
        appDelegate.pannelCompletionHandler(.cancel)
        XCTAssertFalse(appDelegate.isPanelOpen)
    }
}
