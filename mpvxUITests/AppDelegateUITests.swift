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
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testLaunchMpvWithCustomMpv() {
        let app = XCUIApplication()
        app.launchArguments = ["\(argMpvBinaryPath)=/usr/bin/xcrun"]
        app.open(bigBuckBunnyURL)
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testLaunchMpvWithNoMpv() {
        let app = XCUIApplication()
        app.launchArguments = ["\(argMpvBinaryPath)=nil"]
        app.open(bigBuckBunnyURL)
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
        let alert = XCUIApplication().dialogs["alert"]
        let openHelpButton = alert.buttons["Open Help"]
        XCTAssertTrue(openHelpButton.waitForExistence(timeout: 5))
        openHelpButton.click()
        app.open(bigBuckBunnyURL)
        let cancelButton = alert.buttons["Cancel"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5))
        cancelButton.click()
    }
}
