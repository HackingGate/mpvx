import Testing
@testable import mpvx

struct MpvLauncherErrorTests {
    @Test func testErrorDescription() async throws {
        let error = MpvLauncherError.mpvAlreadyRunning
        #expect(error.localizedDescription == "MPV is already running.", "Expected description doesn't match")
    }

    @Test func testFailureReason() async throws {
        let error = MpvLauncherError.mpvAlreadyRunning
        #expect(error.failureReason == "Another instance of MPV is still active.", "Expected failure reason doesn't match")
    }

    @Test func testRecoverySuggestion() async throws {
        let error = MpvLauncherError.mpvAlreadyRunning
        #expect(error.recoverySuggestion == "Please close the existing MPV instance and try again.", "Expected recovery suggestion doesn't match")
    }

    @Test func testHelpAnchor() async throws {
        let error = MpvLauncherError.mpvAlreadyRunning
        #expect(error.helpAnchor == "mpvAlreadyRunningHelp", "Expected help anchor doesn't match")
    }
}
