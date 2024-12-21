import XCTest

@MainActor
final class AppDelegateUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = true
    }

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
    }

    override func tearDown() {
        app.terminate()
        super.tearDown()
    }

    func testLaunchMpv() {
        app.launch()
        XCTAssertTrue(XCUIApplication().menuBars.menuBarItems["mpvx"].waitForExistence(timeout: 5))
        XCUIApplication().menuBars.menuBarItems["mpvx"].click()
        XCUIApplication().menuItems["Hide Others"].click()
        var attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch open panel screen"
        attachment.lifetime = .keepAlways
        add(attachment)
        app.open(bigBuckBunnyURL)
        sleep(10)
        attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch URL screen"
        attachment.lifetime = .keepAlways
        add(attachment)
        XCUIApplication().menuBars.menuBarItems["mpvx"].click()
        XCUIApplication().menuItems["Quit mpvx"].click()
        XCTAssertFalse(XCUIApplication().menuBars.menuBarItems["mpvx"].waitForExistence(timeout: 5))
    }

    func testLaunchMpvLaunchFail() {
        app.open(URL(string: "https://example.com")!)
        sleep(10)
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch wrong URL screen"
        attachment.lifetime = .keepAlways
        add(attachment)
        XCUIApplication().menuBars.menuBarItems["mpvx"].click()
        XCUIApplication().menuItems["Quit mpvx"].click()
        XCTAssertFalse(XCUIApplication().menuBars.menuBarItems["mpvx"].waitForExistence(timeout: 5))
    }

    func testLaunchMpvWithCustomMpv() {
        app.launchArguments = ["\(argMpvBinaryPath)=/usr/bin/xcrun"]
        app.open(bigBuckBunnyURL)
        sleep(10)
        XCTAssertTrue(XCUIApplication().menuBars.menuBarItems["mpvx"].waitForExistence(timeout: 5))
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch URL with wrong mpv screen"
        attachment.lifetime = .keepAlways
        add(attachment)
        XCUIApplication().menuBars.menuBarItems["mpvx"].click()
        XCUIApplication().menuItems["Quit mpvx"].click()
        XCTAssertFalse(XCUIApplication().menuBars.menuBarItems["mpvx"].waitForExistence(timeout: 5))
    }

    func testLaunchMpvWithNoMpvOpenHelp() {
        app.launchArguments = ["\(argMpvBinaryPath)=nil"]
        app.open(bigBuckBunnyURL)
        sleep(10)
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

    func testLaunchMpvWithNoMpvCancel() {
        app.launchArguments = ["\(argMpvBinaryPath)=nil"]
        app.open(bigBuckBunnyURL)
        sleep(10)
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
