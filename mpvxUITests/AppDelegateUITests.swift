import XCTest

final class AppDelegateUITests: XCTestCase {
    let mpvPathProvider: MpvPathProviding = MpvPathProvider()

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunchMpv() {
        let app = XCUIApplication()
        app.open(bigBuckBunnyURL)
        sleep(5)
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch URL screen"
        attachment.lifetime = .keepAlways
        add(attachment)
        XCUIApplication().menuBars.menuBarItems["mpvx"].click()
        XCUIApplication().menuItems["Quit mpvx"].click()
        XCTAssertFalse(XCUIApplication().menuBars.menuBarItems["mpvx"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testLaunchMpvWithCustomMpv() {
        let app = XCUIApplication()
        app.launchArguments = ["\(argMpvBinaryPath)=/usr/bin/xcrun"]
        app.open(bigBuckBunnyURL)
        sleep(5)
        XCTAssertTrue(XCUIApplication().menuBars.menuBarItems["mpvx"].waitForExistence(timeout: 5))
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch URL with wrong mpv screen"
        attachment.lifetime = .keepAlways
        add(attachment)
        XCUIApplication().menuBars.menuBarItems["mpvx"].click()
        XCUIApplication().menuItems["Quit mpvx"].click()
        XCTAssertFalse(XCUIApplication().menuBars.menuBarItems["mpvx"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testLaunchMpvWithNoMpvOpenHelp() {
        let app = XCUIApplication()
        app.launchArguments = ["\(argMpvBinaryPath)=nil"]
        app.open(bigBuckBunnyURL)
        sleep(5)
        XCTAssertTrue(XCUIApplication().menuBars.menuBarItems["mpvx"].waitForExistence(timeout: 5))
        XCUIApplication().menuBars.menuBarItems["mpvx"].click()
        XCUIApplication().menuItems["Hide Others"].click()
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch URL with no mpv screen"
        attachment.lifetime = .keepAlways
        add(attachment)
        let alert = XCUIApplication().dialogs["alert"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        let openHelpButton = alert.buttons["Open Help"]
        XCTAssertTrue(openHelpButton.waitForExistence(timeout: 5))
        openHelpButton.click()
        XCTAssertFalse(alert.waitForExistence(timeout: 5))
        XCUIApplication().menuBars.menuBarItems["mpvx"].click()
        XCUIApplication().menuItems["Quit mpvx"].click()
        XCTAssertFalse(XCUIApplication().menuBars.menuBarItems["mpvx"].waitForExistence(timeout: 5))
    }
    
    @MainActor
    func testLaunchMpvWithNoMpvCancel() {
        let app = XCUIApplication()
        app.launchArguments = ["\(argMpvBinaryPath)=nil"]
        app.open(bigBuckBunnyURL)
        sleep(5)
        XCTAssertTrue(XCUIApplication().menuBars.menuBarItems["mpvx"].waitForExistence(timeout: 5))
        XCUIApplication().menuBars.menuBarItems["mpvx"].click()
        XCUIApplication().menuItems["Hide Others"].click()
        let alert = XCUIApplication().dialogs["alert"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        let cancelButton = alert.buttons["Cancel"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5))
        cancelButton.click()
        XCTAssertFalse(alert.waitForExistence(timeout: 5))
        XCUIApplication().menuBars.menuBarItems["mpvx"].click()
        XCUIApplication().menuItems["Quit mpvx"].click()
        XCTAssertFalse(XCUIApplication().menuBars.menuBarItems["mpvx"].waitForExistence(timeout: 5))
    }
}
